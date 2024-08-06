import { createClient } from '@supabase/supabase-js';

// Function to load configuration based on the environment
async function loadConfig(environment) {
  try {
    const configFilePath = `./config/app_config_${environment}.json`;
    const configFile = await Deno.readTextFile(configFilePath);
    return JSON.parse(configFile);
  } catch (error) {
    console.error(`Failed to load configuration file for environment ${environment}:`, error);
    throw error;
  }
}

// Determine the environment (could be passed as a command line argument or set in some other way)
const environment = Deno.env.get('ENVIRONMENT') || 'dev';

// Load the configuration
const config = await loadConfig(environment);

// Get Supabase URL and Service Role Key from the configuration
const supabaseUrl = config.SUPABASE_URL;
const supabaseServiceRoleKey = config.SUPABASE_SERVICE_ROLE_KEY;

// Create Supabase client
const supabase = createClient(supabaseUrl, supabaseServiceRoleKey);

async function deleteUserFiles(userId) {
  let offset = 0;
  const limit = 100;
  let files;

  try {
    do {
      const { data, error: listError } = await supabase
        .storage
        .from('item_pics')
        .list(userId + '/', { limit, offset });

      if (listError) {
        console.error('Error listing files:', listError);
        throw listError;
      }

      files = data;

      for (const file of files) {
        const { error: deleteError } = await supabase
          .storage
          .from('item_pics')
          .remove([userId + '/' + file.name]);

        if (deleteError) {
          console.error('Error deleting file:', deleteError);
          throw deleteError;
        }
      }

      offset += limit;
    } while (files.length === limit);
  } catch (error) {
    console.error('Failed to delete user files:', error);
    throw error;
  }
}

Deno.serve(async (req) => {
  try {
    const { userId } = await req.json();
    if (!userId) {
      return new Response(JSON.stringify({ error: 'User ID is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    console.log(`Deleting files for user: ${userId}`);
    await deleteUserFiles(userId);

    console.log(`Deleting user account: ${userId}`);
    const { error: userDeleteError } = await supabase
      .from('auth.users')
      .delete()
      .eq('id', userId);

    if (userDeleteError) {
      console.error('Error deleting user account:', userDeleteError);
      throw userDeleteError;
    }

    return new Response(JSON.stringify({ message: 'User folder and account deleted successfully' }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error processing request:', error);
    return new Response(JSON.stringify({ error: 'Failed to delete user folder and account' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
});
