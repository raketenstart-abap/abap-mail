interface ZIF_MAIL_DOCUMENT
  public .


  methods CREATE
    importing
      !MAIL type ZST_MAIL_MESSAGE
    returning
      value(RESULT) type ref to CL_BCS
    raising
      ZCX_MAIL_DOCUMENT .
endinterface.
