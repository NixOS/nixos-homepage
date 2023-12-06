import { DOMParser, XMLSerializer } from '@xmldom/xmldom'
import { readFileSync, writeFileSync } from 'fs'
import TurndownService from 'turndown'

function generateMDCOntent(collectionName) {
    const fileContents = readFileSync(`blog/${collectionName}.xml`, 'utf8')
    const doc = new DOMParser().parseFromString(fileContents, 'text/xml')
    const els = Array.from(doc.getElementsByTagName('item'))
    els.forEach((item) => {
        const id = item.getElementsByTagName('title')[0].getAttribute('id')
        const title = item.getElementsByTagName('title')[0].textContent.replace(/(\r\n|\n|\r)/gm, "").replace(/ +(?= )/g,'');
        const pubDate = new Date(item.getElementsByTagName('pubDate')[0].textContent)
        const content = new TurndownService().turndown(new XMLSerializer().serializeToString(item.getElementsByTagName('description')[0]))
        writeFileSync(`src/contant/blog/${collectionName}/${pubDate.toISOString().substring(0,10)}_${id}.md`, `--
id: ${id}
title:${title}
date: ${pubDate.toISOString()}
category: ${collectionName}
---
${content}`)
    })
}

generateMDCOntent('stories')
generateMDCOntent('announcements')