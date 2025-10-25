export interface Project {
  title: string;
  description: string;
  image: string;
  url: string;
  tags: string[];
  featured?: boolean;
}

export interface Skill {
  name: string;
  level: string;
}

export interface WorkExperience {
  company: string;
  title: string;
  years: string;
  description: string[];
}

export interface Education {
  school: string;
  degree: string;
  startDate: string;
  endDate: string;
}

export interface SocialLink {
  name: string;
  url: string;
  className: string;
}

export interface PersonalInfo {
  name: string;
  occupation: string;
  description: string;
  image: string;
  bio: string;
  contactMessage: string;
  email: string;
  phone: string;
  address: {
    city: string;
    zip: string;
  };
  website: string;
  social: SocialLink[];
}

export interface ResumeData {
  main: PersonalInfo;
  resume: {
    skillMessage: string;
    education: Education[];
    work: WorkExperience[];
    skills: Skill[];
  };
  portfolio: {
    projects: Project[];
  };
  testimonials: {
    testimonials: {
      text: string;
      user: string;
    }[];
  };
  medium: {
    username: string;
  };
}

export const portfolioProjects: Project[] = [
  {
    title: "EMQQQ",
    description:
      "This Line bot is designed to keep you entertained, informed, and organized—all in one place!",
    image: "emqqq.png",
    url: "https://emqqq.com",
    tags: ["Line Bot", "Node.js", "MCP", "LLM Integration"],
    featured: true,
  },
  {
    title: "LinkLoom",
    description:
      "A simple and fast website for shortening and managing URLs efficiently.",
    image: "linkloom.png",
    url: "https://linkloom.link",
    tags: ["React", "TypeScript", "Node.js"],
    featured: true,
  },
  {
    title: "Identique",
    description:
      "A fast and secure website for instantly validating ID numbers with accuracy and ease.",
    image: "identique.png",
    url: "https://identique.org",
    tags: ["React", "TypeScript", "FastAPI"],
    featured: true,
  },
  {
    title: "FurMen",
    description:
      "Modern pet care management platform with React and NestJS backend",
    image: "furmen.png",
    url: "https://furmen.net",
    tags: ["React", "TypeScript", "NestJS"],
    featured: true,
  },
  {
    title: "tm1npm",
    description:
      "NPM package providing TypeScript utilities for IBM Planning Analytics (TM1) API integration",
    image: "tm1npm.png",
    url: "https://www.npmjs.com/package/tm1npm",
    tags: ["TypeScript", "NPM", "IBM Planning Analytics"],
    featured: true,
  },
];

export const personalInfo: PersonalInfo = {
  name: "Angus Hsu",
  occupation: "Software Engineer",
  description:
    "Innovative software developer with experience in designing, developing, and deploying scalable solutions. Skilled in front-end and back-end development, SDLC, and cross-functional collaboration. Proficient in modern languages and frameworks, focused on secure, efficient, and user-friendly applications.",
  image: "angus-self.jpg",
  bio: "Innovative software developer with experience in designing, developing, and deploying scalable solutions. Skilled in front-end and back-end development, SDLC, and cross-functional collaboration. Proficient in modern languages and frameworks, focused on secure, efficient, and user-friendly applications.",
  contactMessage:
    "Please contact me if you've any interest in what I've post here!!",
  email: "apangus611@gmail.com",
  phone: "+886-918540249",
  address: {
    city: "Taipei (Taiwan)",
    zip: "234",
  },
  website: "https://www.angushsu.me",
  social: [
    {
      name: "linkedin",
      url: "https://www.linkedin.com/in/angushsu611/",
      className: "fab fa-linkedin",
    },
    {
      name: "github",
      url: "https://github.com/AngusHsu",
      className: "fab fa-github",
    },
    {
      name: "mail",
      url: "mailto:apangus611@gmail.com",
      className: "fa fa-envelope",
    },
    {
      name: "medium",
      url: "https://medium.com/@apangus611",
      className: "fab fa-medium-m",
    },
  ],
};

export const skills: string[] = [
  "React",
  "Webpack",
  "Next.js",
  "Tailwind CSS",
  "Jest",
  "Python",
  "Node.js",
  "NestJS",
  "PostgreSQL",
  "MongoDB",
  "Docker",
  "AWS",
  "Shell",
  "E2E Testing",
];

export const education: Education[] = [
  {
    school: "National Taiwan University",
    degree: "Communication Engineering (Master's Degree)",
    startDate: "Sep 2018",
    endDate: "Sep 2020",
  },
  {
    school: "National Chung Cheng University",
    degree: "Communication Engineering (Bachelor's Degree)",
    startDate: "Sep 2012",
    endDate: "Jun 2016",
  },
];

export const workExperience: WorkExperience[] = [
  {
    company: "Cubewise",
    title: "Web developer",
    years: "Jan 2022 - Present",
    description: [
      "Designed and developed an automated reporting system using Flask, PostgreSQL, and React that consolidates data across company products into interactive dashboards—delivering daily revenue, customer, and product insights to 10+ stakeholders and eliminating over 10 hours of manual reporting work company-wide.",
      "Built an AI-powered analytics platform with a React/TypeScript frontend and FastAPI backend, implementing the Model Context Protocol to bridge IBM Planning Analytics with conversational AI assistants (Copilot Studio, LibreChat). Reduced query complexity by 80% and enabled 100+ non-technical users to access enterprise OLAP data through natural-language queries.",
      "Collaborated with UK colleagues to develop a Next.js web application utilizing Handsontable modules for efficiently managing datasets exceeding 100,000 rows across 20+ columns—achieving a 60% improvement in processing speed and 45% boost in user productivity while eliminating heavy Excel-based workflows.",
    ],
  },
  {
    company: "EMQ",
    title: "Software developer",
    years: "Aug 2019 - Jan 2022",
    description: [
      "Modernized the internal website by migrating from jQuery to React and integrating Role-Based Access Control (RBAC) modules—enhancing performance, improving user experience, and enabling secure access management for 100+ users.",
      "Developed a cross-product React component library with Storybook to standardize UI patterns across internal applications—accelerating frontend development and ensuring consistent design quality.",
      "Collaborated with the team to architect a containerized end-to-end testing environment using Docker, TestCafe, and AWS to automate regression testing—eliminating one hour of daily manual QA work and detecting bugs before production release.",
      "Built an AWS SAM–based serverless function to automate daily exchange rate retrieval and Google Sheets updates—removing manual data entry and ensuring real-time currency accuracy.",
    ],
  },
  {
    company: "EMQ",
    title: "Operation team lead",
    years: "Dec 2018 - Jul 2019",
    description: [
      "Work with the team to develop, improve, and execute operational processes & procedures.",
      "Work closely with our Network team to understand new partner integrations, define the processes & procedures & improve ongoing integrations.",
      "Collaborate with other teams to drive system improvements that help us deliver results quicker.",
      "Execute daily processes resolving any incidents efficiently.",
      "Mentor, guide and train junior staff members.",
    ],
  },
  {
    company: "EMQ",
    title: "Operation assistant",
    years: "Oct 2016 - Dec 2018",
    description: [
      "Work with the team to develop, improve, and execute operational processes & procedures.",
      "Work closely with our Network team to understand new partner integrations, define the processes & procedures & improve ongoing integrations.",
      "Collaborate with other teams to drive system improvements that help us deliver results quicker.",
      "Execute daily processes resolving any incidents efficiently.",
    ],
  },
];
