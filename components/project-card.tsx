"use client";

import Image from "next/image";
import Link from "next/link";
import { ExternalLink, Github } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import type { Project } from "@/lib/data";

interface ProjectCardProps {
  project: Project;
  className?: string;
}

export function ProjectCard({ project, className }: ProjectCardProps) {
  return (
    <Card className={`group overflow-hidden transition-all hover:shadow-lg ${className}`}>
      <div className="relative overflow-hidden">
        <Image
          src={`/images/portfolio/${project.image}`}
          alt={`${project.title} - ${project.description.slice(0, 100)}${project.description.length > 100 ? '...' : ''}`}
          width={400}
          height={250}
          className="h-48 w-full object-cover transition-transform group-hover:scale-105"
        />
        <div className="absolute inset-0 bg-black/60 opacity-0 transition-opacity group-hover:opacity-100">
          <div className="flex h-full items-center justify-center gap-2">
            <Button asChild size="sm" variant="secondary">
              <Link href={project.url} target="_blank" rel="noopener noreferrer">
                <ExternalLink className="mr-2 h-4 w-4" />
                Visit
              </Link>
            </Button>
          </div>
        </div>
      </div>
      <CardHeader>
        <CardTitle className="text-xl">{project.title}</CardTitle>
        <CardDescription className="line-clamp-2">{project.description}</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="flex flex-wrap gap-2">
          {project.tags.map((tag) => (
            <Badge key={tag} variant="secondary" className="text-xs">
              {tag}
            </Badge>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}