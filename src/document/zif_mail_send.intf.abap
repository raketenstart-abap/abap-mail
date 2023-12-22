interface ZIF_MAIL_SEND
  public .


  constants:
    BEGIN OF sc_mail_type .
  CONSTANTS htm TYPE so_obj_tp VALUE 'HTM'.
  CONSTANTS END OF sc_mail_type .

  methods EXECUTE
    importing
      !IT_MAIL_SERVICES type ZTT_MAIL_DOCUMENT
    raising
      ZCX_MAIL_SEND .
endinterface.
