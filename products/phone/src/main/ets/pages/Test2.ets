@Entry
@Component
struct t {
  @State d: Date = new Date()

  build() {
    Column() {
      Text(this.d.getMonth().toString())
    }
  }
}
