"use client";

import Image from "next/image";
import Link from "next/link";
import { Github, Linkedin, Mail, ExternalLink, Download } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import type { PersonalInfo } from "@/lib/data";

interface HeroSectionProps {
  personalInfo: PersonalInfo;
}

export function HeroSection({ personalInfo }: HeroSectionProps) {
  const getSocialIcon = (name: string) => {
    switch (name.toLowerCase()) {
      case "github":
        return <Github className="h-5 w-5" />;
      case "linkedin":
        return <Linkedin className="h-5 w-5" />;
      case "mail":
        return <Mail className="h-5 w-5" />;
      default:
        return <ExternalLink className="h-5 w-5" />;
    }
  };

  return (
    <section className="min-h-screen flex items-center justify-center py-20 px-4 sm:px-6 lg:px-8">
      <div className="max-w-6xl mx-auto">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          {/* Text Content */}
          <header className="space-y-8">
            <div className="space-y-4">
              <Badge variant="outline" className="text-sm">
                {personalInfo.address.city}
              </Badge>
              <h1 className="text-5xl lg:text-6xl font-bold tracking-tight">
                Hi, I'm{" "}
                <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                  {personalInfo.name}
                </span>
              </h1>
              <h2 className="text-2xl lg:text-3xl font-semibold text-muted-foreground">
                {personalInfo.occupation}
              </h2>
            </div>

            <p className="text-lg text-muted-foreground leading-relaxed max-w-2xl">
              {personalInfo.description}
            </p>

            {/* Social Links */}
            <div className="flex flex-wrap gap-4">
              {personalInfo.social.slice(0, 4).map((social) => (
                <Button
                  key={social.name}
                  asChild
                  variant="outline"
                  size="lg"
                  className="group"
                >
                  <Link
                    href={social.url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex items-center gap-2"
                  >
                    {getSocialIcon(social.name)}
                    <span className="capitalize">{social.name}</span>
                  </Link>
                </Button>
              ))}
            </div>

            {/* CTA Buttons */}
            <div className="flex flex-wrap gap-4 pt-4">
              <Button asChild size="lg" className="group">
                <Link href="#portfolio">
                  View My Work
                  <ExternalLink className="ml-2 h-4 w-4 transition-transform group-hover:translate-x-1" />
                </Link>
              </Button>
              <Button asChild variant="outline" size="lg" className="group">
                <Link
                  href="https://drive.google.com/file/d/1i-caH2CWhDK6iQQTrmyO6jDCyFGljyCo/view"
                  target="_blank"
                  rel="noopener noreferrer"
                  download="Angus_Hsu_Resume.pdf"
                >
                  <Download className="mr-2 h-4 w-4 transition-transform group-hover:scale-110" />
                  Download Resume
                </Link>
              </Button>
            </div>
          </header>

          {/* Profile Image */}
          <aside className="flex justify-center lg:justify-end">
            <div className="relative">
              <div className="absolute inset-0 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full blur-2xl opacity-20 scale-110"></div>
              <div className="relative bg-gradient-to-r from-blue-600 to-purple-600 p-1 rounded-full">
                <Image
                  src={`/images/${personalInfo.image}`}
                  alt={`${personalInfo.name} - ${personalInfo.occupation}, Professional headshot of a full-stack developer`}
                  width={400}
                  height={400}
                  className="rounded-full bg-background"
                  priority
                />
              </div>
            </div>
          </aside>
        </div>
      </div>
    </section>
  );
}
