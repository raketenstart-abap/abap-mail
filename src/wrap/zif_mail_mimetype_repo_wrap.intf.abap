interface ZIF_MAIL_MIMETYPE_REPO_WRAP
  public .


  methods GET
    importing
      !IV_URL type STRING
    returning
      value(RESULT) type ZST_MAIL_WRAP_MIME_REPO
    raising
      ZCX_MAIL_MIMETYPE_REPO_WRAP .
  methods GET_PROPERTIES
    importing
      !IV_URL type STRING
    returning
      value(RESULT) type ZST_MAIL_WRAP_MIME_REPO_PROPS
    raising
      ZCX_MAIL_MIMETYPE_REPO_WRAP .
endinterface.
