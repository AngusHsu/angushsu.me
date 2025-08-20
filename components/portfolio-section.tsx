"use client";

import { ProjectCard } from "./project-card";
import type { Project } from "@/lib/data";

interface PortfolioSectionProps {
  projects: Project[];
}

export function PortfolioSection({ projects }: PortfolioSectionProps) {
  const featuredProjects = projects.filter(project => project.featured);
  const otherProjects = projects.filter(project => !project.featured);

  return (
    <section className="py-20 px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto" aria-labelledby="portfolio-heading">
      <header className="text-center mb-16">
        <h2 id="portfolio-heading" className="text-4xl font-bold tracking-tight text-foreground mb-4">
          Featured Projects
        </h2>
        <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
          Here are some of my recent projects that showcase my skills and experience in web development.
        </p>
      </header>

      {/* Featured Projects */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-16" role="list" aria-label="Featured projects">
        {featuredProjects.map((project) => (
          <article key={project.title} role="listitem">
            <ProjectCard project={project} />
          </article>
        ))}
      </div>

      {/* Other Projects */}
      {otherProjects.length > 0 && (
        <>
          <header className="text-center mb-12">
            <h3 className="text-2xl font-semibold text-foreground mb-2">
              Other Projects
            </h3>
            <p className="text-muted-foreground">
              Additional projects and experiments
            </p>
          </header>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" role="list" aria-label="Other projects">
            {otherProjects.map((project) => (
              <article key={project.title} role="listitem">
                <ProjectCard project={project} />
              </article>
            ))}
          </div>
        </>
      )}
    </section>
  );
}