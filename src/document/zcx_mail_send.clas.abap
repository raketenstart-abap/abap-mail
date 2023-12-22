class ZCX_MAIL_SEND definition
  public
  inheriting from ZCX_ROOT
  create public .

public section.

  data MT_BAPIRET type BAPIRET2_TAB .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !MT_BAPIRET type BAPIRET2_TAB optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_MAIL_SEND IMPLEMENTATION.


  method CONSTRUCTOR ##ADT_SUPPRESS_GENERATION.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->MT_BAPIRET = MT_BAPIRET .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
