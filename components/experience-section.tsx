"use client";

import { Calendar, MapPin } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import type { WorkExperience, Education } from "@/lib/data";

interface ExperienceSectionProps {
  workExperience: WorkExperience[];
  education: Education[];
}

export function ExperienceSection({ workExperience, education }: ExperienceSectionProps) {
  return (
    <section className="py-20 px-4 sm:px-6 lg:px-8">
      <div className="max-w-6xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold tracking-tight text-foreground mb-4">
            Experience & Education
          </h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            My professional journey and educational background.
          </p>
        </div>

        {/* Work Experience */}
        <div className="mb-20">
          <h3 className="text-2xl font-semibold text-foreground mb-8 text-center">Work Experience</h3>
          <div className="space-y-6 max-w-4xl mx-auto">
            {workExperience.map((job, index) => (
              <Card key={index} className="relative">
                <CardHeader>
                  <div className="flex items-start justify-between">
                    <div>
                      <CardTitle className="text-lg">{job.title}</CardTitle>
                      <p className="text-primary font-medium">{job.company}</p>
                    </div>
                    <Badge variant="outline" className="flex items-center gap-1 shrink-0 ml-2">
                      <Calendar className="h-3 w-3" />
                      {job.years}
                    </Badge>
                  </div>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-2">
                    {job.description.map((desc, descIndex) => (
                      <li key={descIndex} className="text-sm text-muted-foreground leading-relaxed">
                        • {desc}
                      </li>
                    ))}
                  </ul>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>

        {/* Education */}
        <div>
          <h3 className="text-2xl font-semibold text-foreground mb-8 text-center">Education</h3>
          <div className="space-y-6 max-w-4xl mx-auto">
            {education.map((edu, index) => (
              <Card key={index} className="relative">
                <CardHeader>
                  <div className="flex items-start justify-between">
                    <div>
                      <CardTitle className="text-lg">{edu.school}</CardTitle>
                      <p className="text-muted-foreground">{edu.degree}</p>
                    </div>
                    <Badge variant="outline" className="flex items-center gap-1 shrink-0 ml-2">
                      <Calendar className="h-3 w-3" />
                      {edu.startDate} - {edu.endDate}
                    </Badge>
                  </div>
                </CardHeader>
              </Card>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}