import { relationalStore, ValuesBucket } from "@kit.ArkData"

const DB_NAME = 'weather9.db'
const TABLE_NAME = 'weatherlist'
let store: relationalStore.RdbStore | null = null

async function getStore(): Promise<relationalStore.RdbStore> {
  if (store) { return store }
  store = await relationalStore.getRdbStore(getContext(), {
    name: DB_NAME,
    securityLevel: relationalStore.SecurityLevel.S1,
  })
  return store
}

export async function ensureTable(): Promise<void> {
  const s = await getStore()
  const sql = `CREATE TABLE IF NOT EXISTS ${TABLE_NAME} (id INTEGER PRIMARY KEY AUTOINCREMENT, CityCode INTEGER)`
  await s.executeSql(sql)
}

export async function readAll(): Promise<number[]> {
  const s = await getStore()
  const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
  const rs = await s.query(predicates)
  const codes: number[] = []
  while (rs.goToNextRow()) {
    const code = rs.getLong(rs.getColumnIndex('CityCode'))
    codes.push(code)
  }
  return codes
}

export async function saveBulk(codes: number[]): Promise<void> {
  const s = await getStore()
  const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
  const rs = await s.query(predicates)
  if (rs.goToFirstRow()) {
    await s.delete(predicates)
  }
  for (const code of codes) {
    await s.insert(TABLE_NAME, { CityCode: code } as ValuesBucket)
  }
}

export async function insertCode(code: number): Promise<void> {
  const s = await getStore()
  await s.insert(TABLE_NAME, { CityCode: code } as ValuesBucket)
}

export async function deleteCode(code: number): Promise<void> {
  const s = await getStore()
  const predicates = new relationalStore.RdbPredicates(TABLE_NAME)
  predicates.equalTo('CityCode', code)
  await s.delete(predicates)
}
