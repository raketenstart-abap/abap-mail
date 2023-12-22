interface ZIF_MAIL_MESSAGE_BINARY
  public .


  methods BUILD
    importing
      !IV_URL type STRING
    returning
      value(RESULT) type ZST_MAIL_WRAP_MIME_REPO_PROPS .
endinterface.
