CREATE OR REPLACE FUNCTION public.compare_versions(version1 VARCHAR, version2 VARCHAR)
RETURNS INTEGER
SET search_path = ''
AS $$
DECLARE
  v1_major INT DEFAULT 0;
  v1_minor INT DEFAULT 0;
  v1_patch INT DEFAULT 0;
  v2_major INT DEFAULT 0;
  v2_minor INT DEFAULT 0;
  v2_patch INT DEFAULT 0;
BEGIN
  -- Split version1 into major, minor, patch with defaults
  SELECT COALESCE(NULLIF(split_part(version1, '.', 1), ''), '0')::INT,
         COALESCE(NULLIF(split_part(version1, '.', 2), ''), '0')::INT,
         COALESCE(NULLIF(split_part(version1, '.', 3), ''), '0')::INT
  INTO v1_major, v1_minor, v1_patch;

  -- Split version2 into major, minor, patch with defaults
  SELECT COALESCE(NULLIF(split_part(version2, '.', 1), ''), '0')::INT,
         COALESCE(NULLIF(split_part(version2, '.', 2), ''), '0')::INT,
         COALESCE(NULLIF(split_part(version2, '.', 3), ''), '0')::INT
  INTO v2_major, v2_minor, v2_patch;

  -- Compare major version
  IF v1_major > v2_major THEN
    RETURN 1;
  ELSIF v1_major < v2_major THEN
    RETURN -1;
  END IF;

  -- Compare minor version
  IF v1_minor > v2_minor THEN
    RETURN 1;
  ELSIF v1_minor < v2_minor THEN
    RETURN -1;
  END IF;

  -- Compare patch version
  IF v1_patch > v2_patch THEN
    RETURN 1;
  ELSIF v1_patch < v2_patch THEN
    RETURN -1;
  END IF;

  -- Versions are equal
  RETURN 0;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.check_app_version(
  current_version_input VARCHAR      -- Current version sent by the app
)
RETURNS BOOLEAN
SET search_path = ''
AS $$
DECLARE
  min_version VARCHAR;
BEGIN
  -- Input validation: Ensure current_version_input is not NULL or empty
  IF current_version_input IS NULL OR current_version_input = '' THEN
    RAISE EXCEPTION 'Invalid version input: version cannot be NULL or empty';
  END IF;

  -- Get the minimum required version from the app_version table
  SELECT min_supported_version INTO min_version
  FROM public.app_version
  WHERE is_current = TRUE
  ORDER BY updated_at DESC LIMIT 1;

  -- Error handling: Ensure we have a current minimum version
  IF min_version IS NULL THEN
    RAISE EXCEPTION 'No current version found in app_version table';
  END IF;

  -- Use compare_versions to check if the current version is less than the minimum version
  IF public.compare_versions(current_version_input, min_version) < 0 THEN
    RETURN TRUE;  -- Update required
  ELSE
    RETURN FALSE;  -- No update required
  END IF;
END;
$$ LANGUAGE plpgsql;
