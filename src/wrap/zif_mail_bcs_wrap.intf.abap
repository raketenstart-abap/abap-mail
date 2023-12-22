INTERFACE zif_mail_bcs_wrap
  PUBLIC .


  METHODS add_attachment
    IMPORTING
      !io_bcs_document       TYPE REF TO cl_document_bcs
      !iv_attachment_type    TYPE soodk-objtp
      !iv_attachment_subject TYPE sood-objdes
      !iv_attachment_size    TYPE sood-objlen
      !iv_attachment_hex     TYPE solix_tab OPTIONAL
    RAISING
      zcx_mail_bcs_wrap .
  METHODS add_recipient
    IMPORTING
      !io_bcs       TYPE REF TO cl_bcs
      !io_recipient TYPE REF TO if_recipient_bcs
      !iv_copy      TYPE abap_bool DEFAULT abap_false
    RAISING
      zcx_mail_bcs_wrap .
  METHODS add_sender
    IMPORTING
      !io_bcs    TYPE REF TO cl_bcs
      !io_sender TYPE REF TO cl_cam_address_bcs
    RAISING
      zcx_mail_bcs_wrap .
  METHODS create_document
    IMPORTING
      !iv_mail_type    TYPE so_obj_tp
      !iv_subject      TYPE so_obj_des
      !iv_length       TYPE so_obj_len
      !iv_language     TYPE so_obj_la
      !iv_importance   TYPE bcs_docimp
      !iv_sensitivity  TYPE so_obj_sns
      !it_content_text TYPE soli_tab
      !it_content_hex  TYPE solix_tab
      !it_mail_header  TYPE soli_tab
      !iv_vsi_profile  TYPE vscan_profile
    RETURNING
      VALUE(result)    TYPE REF TO cl_document_bcs
    RAISING
      zcx_mail_bcs_wrap .
  METHODS create_document_multirelated
    IMPORTING
      !iv_subject              TYPE so_obj_des
      !iv_language             TYPE so_obj_la OPTIONAL
      !iv_importance           TYPE bcs_docimp OPTIONAL
      !iv_sensitivity          TYPE so_obj_sns OPTIONAL
      !iv_vsi_profile          TYPE vscan_profile OPTIONAL
      !io_multirelated_service TYPE REF TO cl_gbt_multirelated_service OPTIONAL
    RETURNING
      VALUE(result)            TYPE REF TO cl_document_bcs
    RAISING
      zcx_mail_bcs_wrap .
  METHODS create_internet_address
    IMPORTING
      !iv_address_string TYPE ad_smtpadr
      !iv_address_name   TYPE ad_smtpadr OPTIONAL
      !iv_incl_sapuser   TYPE os_boolean OPTIONAL
    RETURNING
      VALUE(result)      TYPE REF TO cl_cam_address_bcs
    RAISING
      zcx_mail_bcs_wrap .
  METHODS create_persistent
    RETURNING
      VALUE(result) TYPE REF TO cl_bcs
    RAISING
      zcx_mail_bcs_wrap .
  METHODS send
    IMPORTING
      !io_bcs              TYPE REF TO cl_bcs
      !iv_send_immediately TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(result)        TYPE abap_bool
    RAISING
      zcx_mail_bcs_wrap .
  METHODS set_document
    IMPORTING
      !io_bcs          TYPE REF TO cl_bcs
      !io_bcs_document TYPE REF TO cl_document_bcs
    RAISING
      zcx_mail_bcs_wrap .
  METHODS xstring_to_solix
    IMPORTING
      !iv_xstring   TYPE xstring
    RETURNING
      VALUE(result) TYPE solix_tab .
ENDINTERFACE.
