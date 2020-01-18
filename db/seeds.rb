[
  ['6F-16', 1],
  ['6F-9', 2],
  ['6-68', 3],
  ['6-5', 4],
  ['UPA-2', 5],
  ['6SF-7C', 6],
  ['UPA-4', 7],
  ['6S-8', 8]
].each do |name, id|
  Line.create(
    { id: id, name: name }
  )
end

[
  [11111111, "キュレル150ML", 300],
  [22222222, "KATE", 200],
  [33333333, "アルビオン", 250],
  [44444444, "MK MILK", 120]
].each do |code, name, per_case|
  Product.create(
    { code: code, name: name, per_case: per_case }
  )
end