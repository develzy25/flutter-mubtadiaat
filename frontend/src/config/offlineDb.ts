import Dexie, { type EntityTable } from 'dexie';

export interface OfflineQueue {
  id?: number; // auto-incremented by dexie
  action: string;
  payload: any;
  status: 'PENDING' | 'SYNCING';
  createdAt: number;
}

export interface OfflineFailed {
  id?: number;
  queueId: number;
  error: string;
  failedAt: number;
}

export interface OfflineLog {
  id?: number;
  queueId: number;
  status: 'SUCCESS' | 'FAILED';
  loggedAt: number;
}

// Create the database
const db = new Dexie('MubtadiatDB') as Dexie & {
  offline_queue: EntityTable<OfflineQueue, 'id'>;
  offline_failed: EntityTable<OfflineFailed, 'id'>;
  offline_logs: EntityTable<OfflineLog, 'id'>;
};

// Schema versioning
db.version(1).stores({
  offline_queue: '++id, action, status, createdAt',
  offline_failed: '++id, queueId, failedAt',
  offline_logs: '++id, queueId, status, loggedAt'
});

export { db };
