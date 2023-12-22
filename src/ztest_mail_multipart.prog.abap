*&---------------------------------------------------------------------*
*& Report ZTEST_MAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_mail_multipart.

CLASS lcl DEFINITION
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS
      get_instance
        RETURNING VALUE(result) TYPE REF TO lcl.

    METHODS
      execute
        RAISING zcx_root.

  PRIVATE SECTION.
    METHODS
      build_mail_documents
        RETURNING VALUE(result) TYPE ztt_mail_document
        RAISING   zcx_mail_document.

    METHODS
      build_mail_message
        RETURNING VALUE(result) TYPE zst_mail_message.

ENDCLASS.

CLASS lcl IMPLEMENTATION.

  METHOD get_instance.
    CREATE OBJECT result.
  ENDMETHOD.

  METHOD execute.
    DATA lo_mail_send      TYPE REF TO zif_mail_send.
    DATA lt_mail_documents TYPE ztt_mail_document.

    CREATE OBJECT lo_mail_send TYPE zcl_mail_send.

    lt_mail_documents = build_mail_documents( ).

    lo_mail_send->execute( lt_mail_documents ).
  ENDMETHOD.

  METHOD build_mail_documents.
    DATA ls_mail TYPE zst_mail_message.

    ls_mail = build_mail_message( ).
    APPEND NEW zcl_mail_document_multi( )->create( ls_mail ) TO result.

    ls_mail = build_mail_message( ).
    APPEND NEW zcl_mail_document_multi( )->create( ls_mail ) TO result.
  ENDMETHOD.

  METHOD build_mail_message.
    " header
    result-header-subject   = 'Title test multipart'.
    result-header-mail_type = 'HTM'.
    result-header-sender    = 'no-reply@a.com'.
    result-header-to        = VALUE #( ( 'a@a.com' ) ).
    result-header-cc        = VALUE #( ( 'a@a.com' ) ).

    " body
    result-body-text_tab    = VALUE #( ( line = '<p>body test multipart</p>' ) ).

    " attachments
    result-attachments      = VALUE #(
      ( NEW zcl_file_pdf( ) )
      ( NEW zcl_file_sap( ) )
      ( NEW zcl_file_xml( ) )
    ).
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  lcl=>get_instance( )->execute( ).
