"use client";

import { useState, useEffect, useCallback } from "react";
import Link from "next/link";
import { Menu, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { ThemeToggle } from "@/components/theme-toggle";
import { cn } from "@/lib/utils";

const HEADER_HEIGHT = 64;
const SCROLL_THRESHOLD = 50;

export function Navigation() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  useEffect(() => {
    let ticking = false;

    const handleScroll = () => {
      if (!ticking) {
        requestAnimationFrame(() => {
          setIsScrolled(window.scrollY > SCROLL_THRESHOLD);
          ticking = false;
        });
        ticking = true;
      }
    };

    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const handleNavClick = useCallback((href: string): void => {
    setIsMobileMenuOpen(false);

    try {
      const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
      const behavior = prefersReducedMotion ? "auto" : "smooth";

      if (href === "#") {
        window.scrollTo({ top: 0, behavior });
        return;
      }

      const targetId = href.replace("#", "");
      const targetElement = document.getElementById(targetId);

      if (targetElement) {
        const elementPosition = targetElement.getBoundingClientRect().top;
        const offsetPosition = elementPosition + window.scrollY - HEADER_HEIGHT;

        window.scrollTo({
          top: offsetPosition,
          behavior
        });
      }
    } catch (error) {
      console.error("Error during scroll navigation:", error);
      // Fallback to default anchor behavior
      const targetId = href.replace("#", "");
      const targetElement = document.getElementById(targetId);
      if (targetElement) {
        targetElement.scrollIntoView();
      }
    }
  }, []);

  const navItems = [
    { href: "#", label: "Home" },
    { href: "#portfolio", label: "Portfolio" },
    { href: "#experience", label: "Experience" },
    { href: "#skills", label: "Skills" },
    { href: "#contact", label: "Contact" },
  ];

  return (
    <nav
      aria-label="Main navigation"
      className={cn(
        "fixed top-0 left-0 right-0 z-50 transition-all duration-200",
        isScrolled ? "bg-background/80 backdrop-blur-md border-b" : "bg-transparent"
      )}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <button
            onClick={() => handleNavClick("#")}
            className="font-bold text-xl cursor-pointer bg-transparent border-0 p-0 hover:text-primary transition-colors"
          >
            Angus Hsu
          </button>

          {/* Desktop Navigation */}
          <div className="hidden md:flex items-center gap-8">
            {navItems.map((item) => (
              <button
                key={item.href}
                onClick={() => handleNavClick(item.href)}
                className="text-sm font-medium hover:text-primary transition-colors cursor-pointer bg-transparent border-0 p-0"
              >
                {item.label}
              </button>
            ))}
            <ThemeToggle />
            <Button asChild size="sm">
              <Link href="mailto:apangus611@gmail.com">
                Get In Touch
              </Link>
            </Button>
          </div>

          {/* Mobile Actions */}
          <div className="md:hidden flex items-center gap-2">
            <ThemeToggle />
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
              aria-label="Toggle navigation menu"
              aria-expanded={isMobileMenuOpen}
              aria-controls="mobile-menu"
            >
              {isMobileMenuOpen ? (
                <X className="h-5 w-5" />
              ) : (
                <Menu className="h-5 w-5" />
              )}
            </Button>
          </div>
        </div>

        {/* Mobile Menu */}
        {isMobileMenuOpen && (
          <div id="mobile-menu" className="md:hidden border-t bg-background/95 backdrop-blur-md">
            <div className="py-4 space-y-2">
              {navItems.map((item) => (
                <button
                  key={item.href}
                  onClick={() => handleNavClick(item.href)}
                  className="block w-full text-left px-4 py-2 text-sm font-medium hover:bg-muted rounded-md transition-colors cursor-pointer bg-transparent border-0"
                >
                  {item.label}
                </button>
              ))}
              <div className="px-4 pt-2">
                <Button asChild size="sm" className="w-full">
                  <Link href="mailto:apangus611@gmail.com">
                    Get In Touch
                  </Link>
                </Button>
              </div>
            </div>
          </div>
        )}
      </div>
    </nav>
  );
}