CLASS zcl_mail_document DEFINITION
  PUBLIC
  INHERITING FROM zca_mail_document
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_mail_document .

    ALIASES create
      FOR zif_mail_document~create .
  PROTECTED SECTION.

    METHODS create_document
        REDEFINITION .
  PRIVATE SECTION.

    DATA ms_mail_body TYPE zst_mail_message_content .
ENDCLASS.



CLASS ZCL_MAIL_DOCUMENT IMPLEMENTATION.


  METHOD create_document.

    TRY.
        DATA(lo_business_mail_service) = super->create_document( ).

        DATA(lo_document) = mo_mail_bcs_wrap->create_document(
          iv_mail_type    = ms_mail_header-mail_type
          iv_subject      = ms_mail_header-subject
          iv_importance   = ms_mail_header-importance
          iv_sensitivity  = ms_mail_header-sensitivity
          iv_language     = ms_mail_header-language
          it_mail_header  = ms_mail_header-header_tab
          it_content_text = ms_mail_body-text_tab
          it_content_hex  = ms_mail_body-hex_tab
          iv_length       = ms_mail_body-length
          iv_vsi_profile  = ms_mail_header-vsi_profile
        ).

        mo_mail_bcs_wrap->set_document(
          io_bcs          = lo_business_mail_service
          io_bcs_document = lo_document
        ).

        result = lo_business_mail_service.

      CATCH zcx_mail_bcs_wrap INTO DATA(lx_core_bcs_wrap).
        RAISE EXCEPTION TYPE zcx_mail_document
          EXPORTING
            textid     = zcx_mail_document=>create_document_error
            mv_message = lx_core_bcs_wrap->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_mail_document~create.

    ms_mail_header = mail-header.
    ms_mail_body   = mail-body.

    TRY.
        result = create_document( ).

      CATCH zcx_mail_bcs_wrap INTO DATA(lx_core_bcs_wrap).
        RAISE EXCEPTION TYPE zcx_mail_document
          EXPORTING
            previous = lx_core_bcs_wrap.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
