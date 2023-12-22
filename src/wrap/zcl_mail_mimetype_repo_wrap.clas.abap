CLASS zcl_mail_mimetype_repo_wrap DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_mail_mimetype_repo_wrap .

    METHODS constructor
      IMPORTING
        !io_file_wrap TYPE REF TO zif_file_wrap OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_file_wrap TYPE REF TO zif_file_wrap .
ENDCLASS.



CLASS zcl_mail_mimetype_repo_wrap IMPLEMENTATION.


  METHOD constructor.

    IF io_file_wrap IS BOUND.
      mo_file_wrap = io_file_wrap.
    ELSE.
      CREATE OBJECT mo_file_wrap TYPE zcl_file_wrap.
    ENDIF.

  ENDMETHOD.


  METHOD zif_mail_mimetype_repo_wrap~get.

    DATA lo_mimetype_repo_api TYPE REF TO if_mr_api.

    lo_mimetype_repo_api = cl_mime_repository_api=>get_api( ).

    lo_mimetype_repo_api->get(
      EXPORTING
        i_url              = iv_url
      IMPORTING
        e_is_folder        = result-is_folder
        e_content          = result-content
        e_loio             = result-mime_key
      EXCEPTIONS
        parameter_missing  = 1
        error_occured      = 2
        not_found          = 3
        permission_failure = 4
        OTHERS             = 5
    ).

    CASE sy-subrc.
      WHEN 1.
        RAISE EXCEPTION TYPE zcx_mail_mimetype_repo_wrap.
      WHEN 2.
        RAISE EXCEPTION TYPE zcx_mail_mimetype_repo_wrap.
      WHEN 3.
        RAISE EXCEPTION TYPE zcx_mail_mimetype_repo_wrap.
      WHEN 4.
        RAISE EXCEPTION TYPE zcx_mail_mimetype_repo_wrap.
      WHEN 5.
        RAISE EXCEPTION TYPE zcx_mail_mimetype_repo_wrap.
    ENDCASE.

  ENDMETHOD.


  METHOD zif_mail_mimetype_repo_wrap~get_properties.

    DATA lo_mimetype_repo_api TYPE REF TO if_mr_api.
    DATA lv_size TYPE i.

    lo_mimetype_repo_api = cl_mime_repository_api=>get_api( ).

    lo_mimetype_repo_api->properties(
      EXPORTING
        i_url               = iv_url
        i_check_authority   = abap_true
      IMPORTING
        e_is_folder         = result-is_folder
        e_mime_type         = result-mime_type
        e_name              = result-name
        e_size              = lv_size
        e_loio              = result-loio
        e_phio              = result-phio
        e_language          = result-language
        e_phio_last_changed = result-phio_last_changed
      EXCEPTIONS
        parameter_missing   = 1
        error_occured       = 2
        not_found           = 3
        permission_failure  = 4
        OTHERS              = 5 ).

    result-extension = mo_file_wrap->read_extension( result-name ).
    result-size      = lv_size.

  ENDMETHOD.
ENDCLASS.
