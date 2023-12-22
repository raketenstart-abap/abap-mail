CLASS zcl_mail_message_signature DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_mail_message_signature .

    METHODS constructor
      IMPORTING
        !io_bcs_wrap      TYPE REF TO zif_mail_bcs_wrap OPTIONAL
        !io_mimetype_repo TYPE REF TO zif_mail_mimetype_repo_wrap OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_bcs_wrap TYPE REF TO zif_mail_bcs_wrap .
    DATA mo_mimetype_repo TYPE REF TO zif_mail_mimetype_repo_wrap .
ENDCLASS.



CLASS ZCL_MAIL_MESSAGE_SIGNATURE IMPLEMENTATION.


  METHOD constructor.

    IF io_bcs_wrap IS BOUND.
      mo_bcs_wrap = io_bcs_wrap.
    ELSE.
      CREATE OBJECT mo_bcs_wrap TYPE zcl_mail_bcs_wrap.
    ENDIF.

    IF io_mimetype_repo IS BOUND.
      mo_mimetype_repo = io_mimetype_repo.
    ELSE.
      CREATE OBJECT mo_mimetype_repo TYPE zcl_mail_mimetype_repo_wrap.
    ENDIF.

  ENDMETHOD.


  METHOD zif_mail_message_signature~build.

    DATA ls_mimetype_props TYPE zst_mail_wrap_mime_repo_props.
    DATA ls_mimetype_repo  TYPE zst_mail_wrap_mime_repo.
    DATA lt_binary_data    TYPE solix_tab.

    TRY.
        ls_mimetype_repo = mo_mimetype_repo->get( iv_url ).
        lt_binary_data   = mo_bcs_wrap->xstring_to_solix( ls_mimetype_repo-content ).

        MOVE-CORRESPONDING mo_mimetype_repo->get_properties( iv_url ) TO ls_mimetype_props.
        ls_mimetype_props-hex_data = lt_binary_data.

        result = ls_mimetype_props.

      CATCH zcx_mail_mimetype_repo_wrap.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
