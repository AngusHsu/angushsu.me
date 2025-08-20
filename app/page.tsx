import { HeroSection } from "@/components/hero-section";
import { PortfolioSection } from "@/components/portfolio-section";
import { ExperienceSection } from "@/components/experience-section";
import { SkillsSection } from "@/components/skills-section";
import { ContactSection } from "@/components/contact-section";
import { portfolioProjects, personalInfo, skills, workExperience, education } from "@/lib/data";

export default function Home() {
  return (
    <main className="min-h-screen">
      <HeroSection personalInfo={personalInfo} />
      <div id="portfolio">
        <PortfolioSection projects={portfolioProjects} />
      </div>
      <div id="experience">
        <ExperienceSection workExperience={workExperience} education={education} />
      </div>
      <div id="skills">
        <SkillsSection skills={skills} />
      </div>
      <div id="contact">
        <ContactSection personalInfo={personalInfo} />
      </div>
    </main>
  );
}