CLASS zcl_mail_send DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_mail_send .

    METHODS constructor
      IMPORTING
        !io_bcs_wrap TYPE REF TO zif_mail_bcs_wrap OPTIONAL .
  PROTECTED SECTION.
PRIVATE SECTION.

  DATA mo_bcs_wrap TYPE REF TO zif_mail_bcs_wrap .

  METHODS send
    IMPORTING
      !io_business_mail_service TYPE REF TO cl_bcs
    RAISING
      zcx_mail_bcs_wrap
      zcx_mail_send .
ENDCLASS.



CLASS ZCL_MAIL_SEND IMPLEMENTATION.


  METHOD constructor.

    IF io_bcs_wrap IS BOUND.
      mo_bcs_wrap = io_bcs_wrap.
    ELSE.
      CREATE OBJECT mo_bcs_wrap TYPE zcl_mail_bcs_wrap.
    ENDIF.

  ENDMETHOD.


  METHOD send.

    DATA(lv_result) = mo_bcs_wrap->send( io_business_mail_service ).

    IF lv_result = space.
      RAISE EXCEPTION TYPE zcx_mail_send.
    ENDIF.

    COMMIT WORK AND WAIT.

  ENDMETHOD.


  METHOD zif_mail_send~execute.

    TRY.
        LOOP AT it_mail_services INTO DATA(lo_mail_service).
          send( lo_mail_service ).
        ENDLOOP.

      CATCH zcx_mail_bcs_wrap INTO DATA(lx_core_bcs_wrap).
        RAISE EXCEPTION TYPE zcx_mail_send
          EXPORTING
            previous = lx_core_bcs_wrap.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
