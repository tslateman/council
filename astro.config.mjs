// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

// https://astro.build/config
export default defineConfig({
  site: "https://tslateman.github.io",
  base: "/council",
  integrations: [
    starlight({
      title: "Council",
      sidebar: [
        {
          label: "Getting Started",
          autogenerate: { directory: "getting-started" },
        },
        {
          label: "Critic",
          autogenerate: { directory: "critic" },
        },
        {
          label: "Mentor",
          autogenerate: { directory: "mentor" },
        },
        {
          label: "Wayfinder",
          autogenerate: { directory: "wayfinder" },
        },
        {
          label: "Marshal",
          autogenerate: { directory: "marshal" },
        },
        {
          label: "Mainstay",
          autogenerate: { directory: "mainstay" },
        },
        {
          label: "Ambassador",
          autogenerate: { directory: "ambassador" },
        },
        {
          label: "Guides",
          autogenerate: { directory: "guides" },
        },
        {
          label: "Decisions",
          autogenerate: { directory: "decisions" },
        },
      ],
    }),
  ],
});
