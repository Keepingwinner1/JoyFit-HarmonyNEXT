export default class Badge {
  imageUrl: string = ''
  description: string = ''

  constructor(imageUrl: string, description: string) {
    this.imageUrl = imageUrl
    this.description = description
  }
}
