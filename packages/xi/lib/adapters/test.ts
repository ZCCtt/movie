const baseUrl = "$$$TODO"

interface AnyCategory {
  id: string | number
  name: string
}

type EPUrl = { name: string, url: string }

type EP = { name: string, urls: Array<EPUrl> }

type AnyVideoKV = Record<string, any>

interface AnyVideo extends AnyVideoKV {
  id: string | number
  name: string
  videos: Record<string, Array<EP>>
}

function parseVideos(cx: any): Record<string, Array<EP>> {
  if (!cx) return {}
  const mainSplitSyb = "$$$"
  const { vod_play_from, vod_play_url } = cx
  if (!vod_play_from || !vod_play_url) return {}
  const tabs = vod_play_from.split(mainSplitSyb)
  const vs = vod_play_url.split(mainSplitSyb)
  const result: Record<string, Array<EP>> = {}
  for (let i = 0; i < tabs.length; i++) {
    const name = tabs[i] as string
    const url = vs[i] as string
    if (!result[name]) result[name] = []
    const urls: Array<{ name: string, url: string }> = []
    for (const item of url.split("#")) {
      const [name, url] = item.split("$")
      urls.push({ name, url })
    }
    result[name].push({ name, urls })
  }
  return result
}

async function getCategory(): Promise<AnyCategory[]> {
  const json = await (await fetch(baseUrl)).json()
  const _ = json['class'] as Array<{
    type_id: string | number
    type_name: string
  }>
  return _.map(item => {
    return { id: item.type_id, name: item.type_name }
  })
}

async function getHome(pg: number, size: number = 20, category: string | number = ""): Promise<AnyVideo[]> {
  let url = baseUrl
  if (category) {
    url += `&ac=cate&t=${category}&pg=${pg}`
  }
  const data = await (await fetch(url)).json()
  const json = data as { list: Array<Record<string, any>> }
  return json['list'].map(item => {
    return <AnyVideo>{
      id: item.vod_id,
      name: item.vod_name,
      videos: parseVideos(item)
    }
  })
}

async function getDetail(id: string | number): Promise<AnyVideo> {
  const url = `${baseUrl}&ac=detail&ids=${id}`
  const data = await (await fetch(url)).json() as { list: Array<Record<string, any>> }
  const detail = data.list[0]
  return <AnyVideo>{
    id: detail.vod_id ?? id,
    name: detail.vod_name,
    videos: parseVideos(detail)
  }
}

async function getSearch(keyword: string, pg: number, size: number = 20): Promise<AnyVideo[]> {
  let url = `${baseUrl}&wd=${keyword}&pg=${pg}`
  const quick = true
  if (quick) url += `&quick=1`
  const data = await (await fetch(url)).json()
  const json = data as { list: Array<Record<string, any>> }
  return json['list'].map(item => {
    return <AnyVideo>{
      id: item.vod_id,
      name: item.vod_name,
      videos: parseVideos(item)
    }
  })
}

async function parseIframe(iframe: string) {
  const url = `${baseUrl}&play=${iframe}`
  const data = await (await fetch(url)).json()
  const json = data as { url: string }
  console.log(json)
  return json.url
}

; (async () => {
  // const categorys = await getCategory()
  // const pg = 1
  // const list = await getHome(pg, 20, categorys[0].id)
  // const detail = await getDetail(list[0].id)
  // console.log(JSON.stringify(detail.videos))

  // const list = await getSearch('黑社会', 1)
  // const detail = await getDetail(list[0].id)
  // const videos = detail.videos
  // const video = videos[Object.keys(videos)[0]]
  // const iframe = video[0].urls[0]
  // const videoRealUrl = await parseIframe(iframe.url)
  // console.log("real video url is ", videoRealUrl)
})()