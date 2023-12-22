class ZCA_MAIL_DOCUMENT definition
  public
  abstract
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IO_MAIL_BCS_WRAP type ref to ZIF_MAIL_BCS_WRAP optional
      !IO_FILE_SCMS_WRAP type ref to ZIF_FILE_SCMS_WRAP optional .
protected section.

  data MO_FILE_SCMS_WRAP type ref to ZIF_FILE_SCMS_WRAP .
  data MO_MAIL_BCS_WRAP type ref to ZIF_MAIL_BCS_WRAP .
  data MS_MAIL_HEADER type ZST_MAIL_MESSAGE_HEADER .

  methods ADD_ATTACHMENTS
    importing
      !IO_BCS_DOCUMENT type ref to CL_DOCUMENT_BCS
      !IT_ATTACHMENTS type ZTT_MAIL_MESSAGE_ATTACHMENTS
    raising
      ZCX_MAIL_BCS_WRAP .
  methods ADD_RECIPIENT
    importing
      !IO_BUSINESS_MAIL_SERVICE type ref to CL_BCS
      !IT_RECIPIENTS type ZTT_MAIL_MESSAGE_TO
      !IV_COPY type ABAP_BOOL default ABAP_FALSE
    raising
      ZCX_MAIL_BCS_WRAP .
  methods ADD_SENDER
    importing
      !IO_BUSINESS_MAIL_SERVICE type ref to CL_BCS
      !IV_SENDER_EMAIL type AD_SMTPADR default 'nao-responda@atem.com.br'
    raising
      ZCX_MAIL_BCS_WRAP .
  methods CREATE_DOCUMENT
    returning
      value(RESULT) type ref to CL_BCS
    raising
      ZCX_MAIL_DOCUMENT .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCA_MAIL_DOCUMENT IMPLEMENTATION.


  METHOD add_attachments.

    LOOP AT it_attachments INTO DATA(lo_attachment).
      TRY.
          DATA(ls_attachment) = lo_attachment->utils( )->retrieve_props( ).

          DATA(ls_attachment_hex) = mo_file_scms_wrap->scms_xstring_to_binary(
            iv_buffer = ls_attachment-raw
          ).

          mo_mail_bcs_wrap->add_attachment(
            io_bcs_document       = io_bcs_document
            iv_attachment_type    = ls_attachment-type
            iv_attachment_subject = CONV #( ls_attachment-name )
            iv_attachment_size    = CONV #( ls_attachment-length )
            iv_attachment_hex     = ls_attachment_hex-binary_tab
          ).

        CATCH zcx_file ##NO_HANDLER.
        CATCH zcx_file_scms_wrap ##NO_HANDLER.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD add_recipient.

    DATA lo_recipient TYPE REF TO if_recipient_bcs.

    LOOP AT it_recipients INTO DATA(lv_recipients).
      lo_recipient = mo_mail_bcs_wrap->create_internet_address( lv_recipients ).

      mo_mail_bcs_wrap->add_recipient(
        io_bcs       = io_business_mail_service
        io_recipient = lo_recipient
        iv_copy      = iv_copy
      ).
    ENDLOOP.

  ENDMETHOD.


  METHOD add_sender.

    CONSTANTS lc_default_sender TYPE ad_smtpadr VALUE 'no-reply@a.com'.

    DATA lo_sender       TYPE REF TO cl_cam_address_bcs.
    DATA lv_sender_email TYPE ad_smtpadr.

    IF iv_sender_email IS INITIAL.
      lv_sender_email = lc_default_sender.
    ELSE.
      lv_sender_email = iv_sender_email.
    ENDIF.

    lo_sender = mo_mail_bcs_wrap->create_internet_address(
      iv_address_string = lv_sender_email
    ).

    mo_mail_bcs_wrap->add_sender(
      io_bcs    = io_business_mail_service
      io_sender = lo_sender
    ).

  ENDMETHOD.


  METHOD constructor.

    IF io_mail_bcs_wrap IS BOUND.
      mo_mail_bcs_wrap = io_mail_bcs_wrap.
    ELSE.
      CREATE OBJECT mo_mail_bcs_wrap TYPE zcl_mail_bcs_wrap.
    ENDIF.

    IF io_file_scms_wrap IS BOUND.
      mo_file_scms_wrap = io_file_scms_wrap.
    ELSE.
      CREATE OBJECT mo_file_scms_wrap TYPE zcl_file_scms_wrap.
    ENDIF.

  ENDMETHOD.


  METHOD create_document.

    DATA lx_core_bcs_wrap TYPE REF TO zcx_mail_bcs_wrap.

    IF ms_mail_header-to IS INITIAL AND ms_mail_header-cc IS INITIAL.
      RAISE EXCEPTION TYPE zcx_mail_document
        EXPORTING
          textid = zcx_mail_document=>recipient_empty.
    ENDIF.

    TRY.
        DATA(lo_business_mail_service) = mo_mail_bcs_wrap->create_persistent( ).

      CATCH zcx_mail_bcs_wrap INTO lx_core_bcs_wrap.
        RAISE EXCEPTION TYPE zcx_mail_document
          EXPORTING
            textid = zcx_mail_document=>create_document_error.
    ENDTRY.

    TRY.
        add_sender(
          io_business_mail_service = lo_business_mail_service
          iv_sender_email          = ms_mail_header-sender
        ).

        add_recipient(
          io_business_mail_service = lo_business_mail_service
          it_recipients            = ms_mail_header-to
        ).

        add_recipient(
          io_business_mail_service = lo_business_mail_service
          it_recipients            = ms_mail_header-cc
          iv_copy                  = abap_true
        ).

      CATCH zcx_mail_bcs_wrap INTO lx_core_bcs_wrap.
        RAISE EXCEPTION TYPE zcx_mail_document
          EXPORTING
            textid = zcx_mail_document=>recipient_empty.
    ENDTRY.

    result = lo_business_mail_service.

  ENDMETHOD.
ENDCLASS.
