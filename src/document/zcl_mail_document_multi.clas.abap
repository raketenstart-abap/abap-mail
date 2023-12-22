CLASS zcl_mail_document_multi DEFINITION
  PUBLIC
  INHERITING FROM zca_mail_document
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_mail_document .

    ALIASES create
      FOR zif_mail_document~create .

    DATA mo_mail_signature TYPE REF TO zif_mail_message_signature .

    METHODS constructor
      IMPORTING
        !io_mail_bcs_wrap     TYPE REF TO zif_mail_bcs_wrap OPTIONAL
        !io_mail_signature    TYPE REF TO zif_mail_message_signature OPTIONAL
        !io_mail_binary       TYPE REF TO zif_mail_message_binary OPTIONAL
        !io_mail_multirelated TYPE REF TO cl_gbt_multirelated_service OPTIONAL .
  PROTECTED SECTION.

    METHODS create_document
        REDEFINITION .
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF sc_html .
    CONSTANTS html_open  TYPE string VALUE '<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.1/">'.
    CONSTANTS head       TYPE string VALUE '<head> <meta charset="UTF-8"> </head>'.
    CONSTANTS body_open  TYPE string VALUE '<body>'.
    CONSTANTS body_close TYPE string VALUE '</body>'.
    CONSTANTS html_close TYPE string VALUE '</html>'.
    CONSTANTS END OF sc_html .
    DATA mo_mail_binary TYPE REF TO zif_mail_message_binary .
    DATA mo_mail_multirelated TYPE REF TO cl_gbt_multirelated_service .
    DATA ms_mail_attachments TYPE ztt_mail_message_attachments .
    DATA ms_mail_binaries TYPE zst_mail_message_binary .
    DATA ms_mail_body TYPE zst_mail_message_content .
    DATA ms_mail_signature TYPE zst_mail_message_signature .

    METHODS build_binaries
      RETURNING
        VALUE(result) TYPE ztt_mail_message_binary_data .
    METHODS build_body
      RETURNING
        VALUE(result) TYPE zst_mail_message_body .
    METHODS build_signature
      RETURNING
        VALUE(result) TYPE zst_mail_wrap_mime_repo_props .
ENDCLASS.



CLASS ZCL_MAIL_DOCUMENT_MULTI IMPLEMENTATION.


  METHOD build_binaries.

    FIELD-SYMBOLS <fs_url> TYPE string.

    LOOP AT ms_mail_binaries-url ASSIGNING <fs_url>.

      DATA(ls_mimetype_props) = mo_mail_signature->build( <fs_url> ).

      mo_mail_multirelated->add_binary_part(
        content      = ls_mimetype_props-hex_data
        filename     = ls_mimetype_props-name
        extension    = CONV so_fileext( ls_mimetype_props-extension )
        content_type = CONV w3conttype( ls_mimetype_props-mime_type )
        length       = ls_mimetype_props-size
        content_id   = ls_mimetype_props-name
      ).

      APPEND CORRESPONDING #( ls_mimetype_props ) TO result.

*      APPEND |<br><img alt="[image]" src="cid:{ ls_mimetype_props-name }" /><br>|
*          TO ms_mail_body-text_tab.

    ENDLOOP.

  ENDMETHOD.


  METHOD build_body.

    DATA lt_text_tab TYPE soli_tab.

    APPEND sc_html-html_open  TO lt_text_tab.
    APPEND sc_html-head       TO lt_text_tab.
    APPEND sc_html-body_open  TO lt_text_tab.

    result-binaries  = build_binaries( ).

    result-signature = build_signature( ).

    APPEND LINES OF ms_mail_body-text_tab
                 TO lt_text_tab.

    APPEND sc_html-body_close TO lt_text_tab.
    APPEND sc_html-html_close TO lt_text_tab.

    ms_mail_body-text_tab[] = lt_text_tab[].

    mo_mail_multirelated->set_main_html(
      content     = ms_mail_body-text_tab
      description = ms_mail_header-subject
    ).

    mo_mail_multirelated->set_main_text(
      content     = ms_mail_body-text_tab
      description = ms_mail_header-subject
    ).

  ENDMETHOD.


  METHOD build_signature.

    CHECK ms_mail_signature-url IS NOT INITIAL.

    DATA(ls_mimetype_props) = mo_mail_signature->build( ms_mail_signature-url ).

    mo_mail_multirelated->add_binary_part(
      content      = ls_mimetype_props-hex_data
      filename     = ls_mimetype_props-name
      extension    = CONV so_fileext( ls_mimetype_props-extension )
      content_type = CONV w3conttype( ls_mimetype_props-mime_type )
      length       = ls_mimetype_props-size
      content_id   = ls_mimetype_props-name
    ).

    MOVE-CORRESPONDING ls_mimetype_props TO result.

    APPEND |<br><img alt="[image]" src="cid:{ ls_mimetype_props-name }" /><br>|
        TO ms_mail_body-text_tab.

  ENDMETHOD.


  METHOD constructor.

    super->constructor(
      io_mail_bcs_wrap = io_mail_bcs_wrap
    ).

    IF io_mail_signature IS BOUND.
      mo_mail_signature = io_mail_signature.
    ELSE.
      CREATE OBJECT mo_mail_signature TYPE zcl_mail_message_signature.
    ENDIF.

    IF io_mail_binary IS BOUND.
      mo_mail_binary = io_mail_binary.
    ELSE.
      CREATE OBJECT mo_mail_binary TYPE zcl_mail_message_binary.
    ENDIF.

    IF io_mail_multirelated IS BOUND.
      mo_mail_multirelated = io_mail_multirelated.
    ELSE.
      CREATE OBJECT mo_mail_multirelated
        EXPORTING
          codepage = 4110.
    ENDIF.

  ENDMETHOD.


  METHOD create_document.

    TRY.
        DATA(ls_business_mail_service) = super->create_document( ).

        build_body( ).

        DATA(lo_document) = mo_mail_bcs_wrap->create_document_multirelated(
          iv_subject              = ms_mail_header-subject
          iv_importance           = ms_mail_header-importance
          iv_sensitivity          = ms_mail_header-sensitivity
          iv_language             = ms_mail_header-language
          iv_vsi_profile          = ms_mail_header-vsi_profile
          io_multirelated_service = mo_mail_multirelated
        ).

        add_attachments(
          io_bcs_document = lo_document
          it_attachments  = ms_mail_attachments
        ).

        mo_mail_bcs_wrap->set_document(
          io_bcs          = ls_business_mail_service
          io_bcs_document = lo_document
        ).

        result = ls_business_mail_service.

      CATCH zcx_mail_bcs_wrap INTO DATA(lx_core_bcs_wrap).
        RAISE EXCEPTION TYPE zcx_mail_document
          EXPORTING
            textid     = zcx_mail_document=>create_document_error
            mv_message = lx_core_bcs_wrap->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_mail_document~create.

    ms_mail_header      = mail-header.
    DELETE ms_mail_header-to WHERE table_line IS INITIAL.
    DELETE ms_mail_header-cc WHERE table_line IS INITIAL.

    ms_mail_body        = mail-body.
    ms_mail_binaries    = mail-binaries.

    ms_mail_attachments = mail-attachments.
    DELETE ms_mail_attachments WHERE table_line IS NOT BOUND.

    ms_mail_signature   = mail-signature.

    result = create_document( ).

  ENDMETHOD.
ENDCLASS.
