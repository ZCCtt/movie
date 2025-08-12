const baseUlr= "http://drpys.nokia.press/api/专享影视?pwd=dzyyds"

interface AnyCategory {
  id: string | number
  name: string
}

type AnyVideoKV = Record<string, any>

interface AnyVideo extends AnyVideoKV {
  id: string | number
  videos: Array<{ epName: string, url: string }>
}

async function getCategory(): Promise<AnyCategory[]> {
  return []
}

async function getHome(pg: number, size: number = 20, category = ""): Promise<AnyVideo[]> {
  return []
}

async function getDetail(id: string | number): Promise<AnyVideo> {
  throw new Error("not implemented.")
}

async function getSearch(keyword: string, pg: number, size: number = 20): Promise<AnyVideo[]> {
  return [] 
}