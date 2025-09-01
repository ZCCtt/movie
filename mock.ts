type VideoDetail = Record<string, any>
interface ISA {
  getCategory(): Promise<Array<{ id: string, name: string }>>
  getHome(page: number, limit: number, category?: string): Promise<VideoDetail[]>   
  getSearch(keyword: string, page: number, limit: number): Promise<VideoDetail[]>
  getDetail(movieId: string): Promise<VideoDetail>
  parseIframe(iframe: string): Promise<string[]>
}

export default class 奈非影视 implements ISA {
  $baseUrl = 'https://nfmovies.av'
  async getCategory() {
    // return (await (await fetch(`${this.$baseUrl}/api/v1/categories`)).json())
    return [
      { id: '1145', name: '全部'},
      { id: 'dianying', name: '电影'},
    ]
  }
  async getHome(page: number, limit: number, category?: string) {
    const resp = await (await fetch(`${this.$baseUrl}/api/home?pg=${page}&limit=${limit}&category=${category}`)).text()
    // 此处解析可能分为三种:
    // 1. JSON: JSON.parse()
    // 2. HTML: createCheerio()
    // 3. XML: createXMLParser() | createCheerio()
    return []
  }
  async getSearch(keyword: string, page: number, limit: number) {
    return []
  }
  async getDetail(movieId: string) {
    return <VideoDetail>{
      id: '',
      title: '',
      smallCoverImage: '',
      extra: {}
    }
  } 
  async parseIframe(iframe: string) {
    return []
  }
}