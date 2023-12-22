CLASS zcl_mail_bcs_wrap DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_mail_bcs_wrap .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mail_bcs_wrap IMPLEMENTATION.


  METHOD zif_mail_bcs_wrap~add_attachment.

    TRY.
        io_bcs_document->add_attachment(
          i_attachment_type    = iv_attachment_type
          i_attachment_subject = iv_attachment_subject
          i_attachment_size    = iv_attachment_size
          i_att_content_hex    = iv_attachment_hex
        ).
      CATCH cx_document_bcs INTO DATA(lx_document_bcs).
        RAISE EXCEPTION TYPE zcx_mail_bcs_wrap
          EXPORTING
            textid     = zcx_mail_bcs_wrap=>document_error
            mv_message = lx_document_bcs->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_mail_bcs_wrap~add_recipient.

    TRY.
        io_bcs->add_recipient(
          i_recipient = io_recipient
          i_copy      = iv_copy
        ).

      CATCH cx_send_req_bcs INTO DATA(lx_send_req_bcs).
        RAISE EXCEPTION TYPE zcx_mail_bcs_wrap
          EXPORTING
            textid     = zcx_mail_bcs_wrap=>document_error
            mv_message = lx_send_req_bcs->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_mail_bcs_wrap~add_sender.

    TRY.
        io_bcs->set_sender( io_sender ).

      CATCH cx_send_req_bcs INTO DATA(lx_send_req_bcs).
        RAISE EXCEPTION TYPE zcx_mail_bcs_wrap
          EXPORTING
            textid     = zcx_mail_bcs_wrap=>document_error
            mv_message = lx_send_req_bcs->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_mail_bcs_wrap~create_document.

    TRY.
        result = cl_document_bcs=>create_document(
          i_type         = iv_mail_type
          i_subject      = iv_subject
          i_length       = iv_length
          i_language     = iv_language
          i_importance   = iv_importance
          i_sensitivity  = iv_sensitivity
          i_text         = it_content_text
          i_hex          = it_content_hex
          i_header       = it_mail_header
          iv_vsi_profile = iv_vsi_profile
        ).

      CATCH cx_document_bcs INTO DATA(lx_document_bcs).
        RAISE EXCEPTION TYPE zcx_mail_bcs_wrap
          EXPORTING
            textid     = zcx_mail_bcs_wrap=>document_error
            mv_message = lx_document_bcs->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_mail_bcs_wrap~create_document_multirelated.

    DATA lv_error_message TYPE string.

    TRY.
        result = cl_document_bcs=>create_from_multirelated(
          i_subject          = iv_subject
          i_language         = iv_language
          i_importance       = iv_importance
          i_sensitivity      = iv_sensitivity
          iv_vsi_profile     = iv_vsi_profile
          i_multirel_service = io_multirelated_service
        ).

      CATCH cx_document_bcs INTO DATA(lx_document_bcs).
        lv_error_message = lx_document_bcs->get_text( ).

      CATCH cx_gbt_mime  INTO DATA(lx_gbt_mime).
        lv_error_message = lx_gbt_mime->get_text( ).

      CATCH cx_bcom_mime INTO DATA(lx_bcom_mime).
        lv_error_message = lx_bcom_mime->get_text( ).
    ENDTRY.

    IF lv_error_message IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_mail_bcs_wrap
        EXPORTING
          textid     = zcx_mail_bcs_wrap=>document_error
          mv_message = lv_error_message.
    ENDIF.

  ENDMETHOD.


  METHOD zif_mail_bcs_wrap~create_internet_address.

    TRY.
        result = cl_cam_address_bcs=>create_internet_address(
          i_address_string = iv_address_string
          i_address_name   = iv_address_name
          i_incl_sapuser   = iv_incl_sapuser
        ).

      CATCH cx_address_bcs INTO DATA(lx_address_bcs).
        RAISE EXCEPTION TYPE zcx_mail_bcs_wrap
          EXPORTING
            textid     = zcx_mail_bcs_wrap=>document_error
            mv_message = lx_address_bcs->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_mail_bcs_wrap~create_persistent.

    TRY.
        result = cl_bcs=>create_persistent( ).

      CATCH cx_send_req_bcs INTO DATA(lx_send_req_bcs).
        RAISE EXCEPTION TYPE zcx_mail_bcs_wrap
          EXPORTING
            textid     = zcx_mail_bcs_wrap=>document_error
            mv_message = lx_send_req_bcs->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_mail_bcs_wrap~send.

    TRY.
        io_bcs->set_send_immediately( iv_send_immediately ).

        result = io_bcs->send( ).

      CATCH cx_send_req_bcs INTO DATA(lx_send_req_bcs).
        RAISE EXCEPTION TYPE zcx_mail_bcs_wrap
          EXPORTING
            textid     = zcx_mail_bcs_wrap=>document_error
            mv_message = lx_send_req_bcs->get_text( ).

      CATCH cx_sy_ref_is_initial.
        RAISE EXCEPTION TYPE zcx_mail_bcs_wrap
          EXPORTING
            textid = zcx_root=>initial_reference.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_mail_bcs_wrap~set_document.

    IF io_bcs IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_mail_bcs_wrap
        EXPORTING
          textid = zcx_mail_bcs_wrap=>initial_reference.
    ENDIF.

    TRY.
        io_bcs->set_document( io_bcs_document ).

      CATCH cx_send_req_bcs INTO DATA(lx_send_req_bcs).
        RAISE EXCEPTION TYPE zcx_mail_bcs_wrap
          EXPORTING
            textid     = zcx_mail_bcs_wrap=>document_error
            mv_message = lx_send_req_bcs->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_mail_bcs_wrap~xstring_to_solix.

    result = cl_bcs_convert=>xstring_to_solix( iv_xstring ).

  ENDMETHOD.
ENDCLASS.
