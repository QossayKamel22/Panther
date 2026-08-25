/**
 * PANTHER wordmark/glyph. The official logo asset lives in the README; this
 * inline glyph is a lightweight stand-in that follows the same visual
 * language (sharp geometric cat silhouette, electric-blue glow) so the app
 * doesn't depend on fetching an external image. Replace `src` below with a
 * locally hosted copy of the official logo when one is added to /public.
 */
export function PantherMark({ size = 28 }: { size?: number }) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 48 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      aria-label="PANTHER"
      role="img"
    >
      <defs>
        <linearGradient id="pantherGlow" x1="0" y1="0" x2="48" y2="48" gradientUnits="userSpaceOnUse">
          <stop offset="0%" stopColor="#7fb4ff" />
          <stop offset="100%" stopColor="#3b82f6" />
        </linearGradient>
      </defs>
      <path
        d="M24 4L34 12V22L44 30L34 28L30 38L24 44L18 38L14 28L4 30L14 22V12L24 4Z"
        stroke="url(#pantherGlow)"
        strokeWidth="2"
        strokeLinejoin="round"
        fill="rgba(59,130,246,0.08)"
      />
      <circle cx="24" cy="21" r="3.2" fill="url(#pantherGlow)" />
    </svg>
  );
}
