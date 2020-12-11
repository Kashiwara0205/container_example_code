type AccoutRecord* = ref object
  name*: string
  id: int
  password: string

type AccoutModel* = ref object
method getAll*(model: AccoutModel): seq[AccoutRecord] {.base.} =
  let acounts = @[
    AccoutRecord(name:"A学生", id: 1, password: "fevxvbtr4"),
    AccoutRecord(name:"D学生", id:2, password: "sfref4erf"),
  ]

  return acounts