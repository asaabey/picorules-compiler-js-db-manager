import sql from 'mssql';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const config: sql.config = {
    server: process.env.MSSQL_SERVER!,
    port: parseInt(process.env.MSSQL_PORT || '1433'),
    database: process.env.MSSQL_DATABASE!,
    user: process.env.MSSQL_USER!,
    password: process.env.MSSQL_PASSWORD!,
    options: {
        encrypt: process.env.MSSQL_ENCRYPT === 'true',
        trustServerCertificate: process.env.MSSQL_TRUST_SERVER_CERTIFICATE === 'true'
    }
};

async function setupDatabase() {
    let pool: sql.ConnectionPool | undefined;
    try {
        console.log('🔌 Connecting to SQL Server...');
        console.log(`   Server: ${config.server}:${config.port}`);
        console.log(`   Database: ${config.database}`);

        pool = await sql.connect(config);
        console.log('✅ Connected successfully!\n');

        // Read setup script
        const setupScript = fs.readFileSync(
            path.join(__dirname, 'test-data/setup-mssql.sql'),
            'utf-8'
        );

        // Split by GO statements
        const batches = setupScript
            .split(/\r?\nGO\r?\n/i)
            .map(batch => batch.trim())
            .filter(batch => batch.length > 0);

        console.log(`📄 Found ${batches.length} SQL batches to execute\n`);

        for (let i = 0; i < batches.length; i++) {
            console.log(`⚙️  Executing batch ${i + 1}/${batches.length}...`);
            const result = await pool.request().query(batches[i]);

            if (result.recordset && result.recordset.length > 0) {
                console.log('   Result:', result.recordset);
            }
        }

        console.log('\n✅ Database setup completed successfully!');
        console.log('\n🧪 You can now run: npm run validate:mssql');

    } catch (err) {
        console.error('❌ Error:', (err as Error).message);
        process.exit(1);
    } finally {
        if (pool) {
            await pool.close();
        }
    }
}

setupDatabase();
