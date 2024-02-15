# abap-mail
ABAP: Mail

Using a standardized framework that is both robust and scalable can significantly boost agility in developing new features. This accelerates delivery and also allows for more extensive analysis of business scenarios and their impacts, ultimately saving valuable time.

* [Dependencies](#dependencies)
* [How to use](#how-to-use)
* [Demonstration and test programs](#demonstration-and-test-programs)
* Examples
  * [Sending basic email](#sending-basic-email)
  * [Sending multipart email with attachments](#sending-multipart-email-with-attachments)


### How to use 

1) Install ABAPGit on your ABAP stack https://docs.abapgit.org/
2) Clone and install dependencies [abap-core](https://github.com/raketenstart-abap/abap-core) and [abap-files](https://github.com/raketenstart-abap/abap-files)
3) Finally, clone repository [abap-mail](https://github.com/raketenstart-abap/abap-mail)
4) Done! The mail framework is ready to use


### **Dependencies**

| Package              | Version  | Repository                                      |
| :------------------- | :------: | :---------------------------------------------: |
| abap-core            |   1.0.0  | https://github.com/raketenstart-abap/abap-core  |
| abap-files           |   1.0.0  | https://github.com/raketenstart-abap/abap-files |

### **Demonstration and test programs**

| Report               | Version  | Description                                                       |
| :------------------- | :------: | :---------------------------------------------------------------- |
| ZTEST_MAIL           |   1.0.1  | Send multiple or single text email                                |
| ZTEST_MAIL_MULTIPART |   1.0.1  | Send multiple or single multipart email, with attachments support |

### Sending basic email

```abap
* mail content
  DATA mail TYPE zst_mail_message.
  mail-header-subject   = 'Title test'.
  mail-header-mail_type = 'TXT'.
  mail-header-sender    = 'no-reply@a.com'.
  mail-header-to        = VALUE #( ( 'a@a.com' ) ).
  mail-header-cc        = VALUE #( ( 'a@a.com' ) ).
  mail-body-text_tab    = VALUE #( ( line = 'body test' ) ).

* create and group multiple emails
DATA mail_documents TYPE ztt_mail_document.
APPEND NEW zcl_mail_document( )->create( mail ) TO mail_documents. " #1
APPEND NEW zcl_mail_document( )->create( mail ) TO mail_documents. " #2

* mail sender
DATA lo_mail_sender TYPE REF TO zif_mail_send.

CREATE OBJECT lo_mail_sender TYPE zcl_mail_send.
lo_mail_sender->execute( mail_documents ).
```

### Sending multipart email with attachments

```abap
* mail content
  " header
  DATA mail TYPE zst_mail_message.

  mail-header-subject   = 'Title test multipart'.
  mail-header-mail_type = 'HTM'.
  mail-header-sender    = 'no-reply@a.com'.
  mail-header-to        = VALUE #( ( 'a@a.com' ) ).
  mail-header-cc        = VALUE #( ( 'a@a.com' ) ).

  " body
  mail-body-text_tab    = VALUE #(
    ( line = '<h1>body test multipart</h1>' )
    ( line = '<h2>body test multipart</h2>' )
    ( line = '<h3>body test multipart</h3>' )
  ).

  " attachments
  mail-attachments      = VALUE #( " package 'abap-files' is needed
    ( NEW zcl_file_pdf( ) )
    ( NEW zcl_file_sap( ) )
    ( NEW zcl_file_xml( ) )
  ).

* create and group multiple emails
DATA mail_documents TYPE ztt_mail_document.
APPEND NEW zcl_mail_document_multi( )->create( mail ) TO mail_documents. " #1
APPEND NEW zcl_mail_document_multi( )->create( mail ) TO mail_documents. " #2

* mail sender
DATA lo_mail_sender TYPE REF TO zif_mail_send.

CREATE OBJECT lo_mail_sender TYPE zcl_mail_send.
lo_mail_sender->execute( mail_documents ).
```
