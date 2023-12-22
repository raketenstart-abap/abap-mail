class ZCL_MAIL_MESSAGE_BINARY definition
  public
  create public .

public section.

  interfaces zif_mail_message_binary .

  methods CONSTRUCTOR
    importing
      !IO_BCS_WRAP type ref to zif_mail_bcs_wrap optional
      !IO_MIMETYPE_REPO type ref to zif_mail_mimetype_repo_wrap optional .
protected section.
private section.

  data MO_BCS_WRAP type ref to zif_mail_bcs_wrap .
  data MO_MIMETYPE_REPO type ref to zif_mail_mimetype_repo_wrap .
ENDCLASS.



CLASS ZCL_MAIL_MESSAGE_BINARY IMPLEMENTATION.


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


  METHOD zif_mail_message_binary~build.

    DATA ls_mimetype_props TYPE zst_mail_wrap_mime_repo_props.
    DATA ls_mimetype_repo  TYPE zst_mail_wrap_mime_repo.
    DATA lt_binary_data    TYPE solix_tab.

    TRY.
        ls_mimetype_repo = mo_mimetype_repo->get( iv_url ).
        lt_binary_data = mo_bcs_wrap->xstring_to_solix( ls_mimetype_repo-content ).

        MOVE-CORRESPONDING mo_mimetype_repo->get_properties( iv_url ) TO ls_mimetype_props.
        ls_mimetype_props-hex_data = lt_binary_data.

        result = ls_mimetype_props.

      CATCH zcx_mail_mimetype_repo_wrap.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
