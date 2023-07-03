# Soundscapes

Entrypoint script: `Soundscapes/playlist2soundscape.py`

### DB tables

- `jobs` - updated for classification job
- `job_params_soundscape` - stores parameters for soundscape jobs
- `soundscape_aggregation_types` - stores the different ways acoustic data can be aggregated (e.g. day of week, hour of day)
- `playlist_recordings` - for getting the recordings for the soundscape

### Operations

#### Process recordings

Calls `processRec()` (defined here) within `Parallel()`
- calls R script `fpeaks.R`, and optionally `h.R` and `aci.R`
    - fpeaks.R
        - archivo <- `readWave()`
        - spec <- `meanSpec(archivo, f=archivo@samp.rate, plot=False, wl=next power of two from sample rate / bin_size (chosen by user) norm=F)`
		- picos <- `fpeaks(spec, freq=as.numeric(frequency), plot=F, threshold=max(threshold, 0.00001)`
    - creates Soundscape: `lib/soundscape/soundscape.py`
