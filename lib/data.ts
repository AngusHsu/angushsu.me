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
    tags: ["Line Bot", "Node.js", "API Integration"],
    featured: true,
  },
  {
    title: "LinkLoom",
    description:
      "A simple and fast website for shortening and managing URLs efficiently.",
    image: "linkloom.png",
    url: "https://linkloom.link",
    tags: ["React", "URL Shortener", "Web App"],
    featured: true,
  },
  {
    title: "Identique",
    description:
      "A fast and secure website for instantly validating ID numbers with accuracy and ease.",
    image: "identique.png",
    url: "https://identique.org",
    tags: ["Validation", "Security", "Web App"],
    featured: true,
  },
  {
    title: "FurMen",
    description:
      "Modern pet care management platform with React and NestJS backend",
    image: "furmen.png",
    url: "https://furmen.net",
    tags: ["React", "TypeScript", "React Native", "NestJS"],
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
      "Designed and developed an automated system capable of exporting reports to designated locations at predetermined times, streamlining data dissemination and ensuring timely access.",
      "Established a zero-to-one web product, overseeing its development from concept to launch, as an OLAP extension web service built with FastAPI and React.",
      "Developed a multi-page web service for comprehensive yearly expense planning, enabling users to organize and track their financial goals efficiently. The application features an intuitive interface for budgeting, forecasting, and managing expenses across different categories.",
      "Developed and designed a Next.js web page that utilizes multiple Handsontable modules with extensive custom styling, handling and organizing large amounts of table data to enhance user-friendliness and efficiency.",
    ],
  },
  {
    company: "EMQ",
    title: "Software developer",
    years: "Aug 2019 - Jan 2022",
    description: [
      "Enhanced the development experience of the internal website by migrating from jQuery to React, integrating RBAC (Role-Based Access Control) modules, and collaborating closely with backend engineers to ensure seamless implementation.",
      "Developed a customer-facing API documentation website using OpenAPI 3.0 and ReDoc.",
      "Developed a cross-product frontend component library using React and Storybook.",
      "Developed an e2e testing environment for websites using Docker, TestCafe, and AWS tools.",
      "Developed a Windows-compatible program using Puppeteer to parallelly retrieve transaction receipts from an online banking system.",
      "Implemented an AWS SAM function to fetch daily exchange rates from the bank and update them in Google Sheets automatically.",
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
