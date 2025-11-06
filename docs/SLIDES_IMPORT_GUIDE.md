# How to Import Slides into Google Slides

## Option 1: Convert to PowerPoint (Recommended)

### Using Pandoc (Best Quality)

1. **Install Pandoc** (if not already installed):
```bash
# macOS
brew install pandoc

# Or download from: https://pandoc.org/installing.html
```

2. **Convert Markdown to PowerPoint**:
```bash
cd docs/
pandoc PRESENTATION_SLIDES.md -o presentation.pptx
```

3. **Upload to Google Slides**:
- Go to https://slides.google.com
- Click "File" → "Import slides"
- Upload `presentation.pptx`
- Select all slides and click "Import"

### Result
- Clean, professional slides
- All formatting preserved
- Ready to customize in Google Slides

---

## Option 2: Use Online Converter

### Via CloudConvert

1. Go to https://cloudconvert.com/md-to-pptx
2. Upload `PRESENTATION_SLIDES.md`
3. Click "Convert"
4. Download the `.pptx` file
5. Import into Google Slides as above

---

## Option 3: Manual Copy (Most Control)

### Step-by-Step

1. **Open Google Slides**:
- Go to https://slides.google.com
- Click "Blank" to create new presentation

2. **Use the Markdown as a Guide**:
- Each `---` marks a new slide
- Each `#` heading is the slide title
- Bullet points and content follow

3. **Copy Slide-by-Slide**:
- Slide 1: Title slide
- Slide 2: "The Problem: Manual Deployment is Broken"
- And so on...

4. **Add Visuals**:
- Insert diagrams where indicated
- Add company logo and branding
- Include screenshots from your demo

---

## Option 4: Use Marp (Developer-Friendly)

### Install and Use Marp

1. **Install Marp CLI**:
```bash
npm install -g @marp-team/marp-cli
```

2. **Convert to PowerPoint**:
```bash
cd docs/
marp PRESENTATION_SLIDES.md --pptx -o presentation.pptx
```

3. **Import to Google Slides** (as described in Option 1)

---

## Recommended Approach

**For best results, use this workflow:**

1. **Convert with Pandoc** → `presentation.pptx`
2. **Import to Google Slides**
3. **Customize**:
   - Add your company branding
   - Insert demo screenshots
   - Adjust colors to match your theme
   - Add transitions if desired
4. **Practice** with the slide deck
5. **Share** with stakeholders

---

## Slide Deck Structure (44 slides)

1. **Title** - Introduction
2. **Problem** - Manual deployment challenges
3. **Cost** - Annual impact
4. **Solution** - Automated pipeline
5. **How It Works** - 5-step process
6. **Demo Intro** - What you'll see
7. **Demo: Repository** - Code structure
8. **Demo: Trigger** - Git push
9. **Demo: Actions** - Workflow in progress
10. **Demo: Results** - Datadog UI
11. **Architecture** - System diagram
12-13. **Scalability** - Time savings, multi-stack
14-16. **Benefits** - Time, errors, monitoring impact
17-19. **ROI** - Investment, Year 1, 5-year
20-23. **Deployment Plan** - Phases, teams, risks, security
24. **Monitoring** - Health checks
25. **Competitive** - Advantages
26. **Success Metrics** - What success looks like
27. **Differentiators** - What makes this special
28. **Future** - Roadmap
29. **Testimonial** - Customer quote
30. **Q&A** - Common questions
31. **Call to Action** - Next steps
32. **Contact** - Resources
33. **Thank You** - Closing
34. **Appendix** - Additional details

---

## Customization Tips

### Branding
- Replace `[Your Name]` with your actual name
- Add your company logo to the title slide
- Use your company's color scheme
- Add footer with company name

### Content
- Add actual demo screenshots to demo slides
- Include real metrics from your environment (if applicable)
- Customize ROI calculations for your org size
- Add customer testimonials if available

### Visuals
Consider adding:
- Architecture diagram as an image (slide 11)
- Chart showing time savings (slide 12)
- Graph of error reduction (slide 15)
- ROI comparison chart (slide 19)
- Photos of team members (slide 21)

### Speaker Notes
Add presenter notes in Google Slides for:
- Key talking points
- Timing guidance (this is a 30-minute deck)
- Transition cues
- Demo instructions

---

## Presentation Settings

### Recommended Settings in Google Slides

**Theme**: Simple, professional
- "Simple Light" or "Simple Dark"
- Or your company's template

**Font Sizes**:
- Title: 44pt
- Headings: 32pt
- Body text: 18-24pt
- Ensure readability from back of room

**Slide Ratio**: 16:9 (default)

**Transitions**: Minimal
- Simple "Fade" or "None"
- Avoid distracting animations

**Presenter View**: Enable
- Shows speaker notes
- Next slide preview
- Timer

---

## Presentation Duration

### Timing Guide (30-minute slot)

- **Slides 1-3** (Problem/Cost): 3 minutes
- **Slides 4-5** (Solution/How): 2 minutes
- **Slides 6-10** (Live Demo): 10 minutes ⭐ Main event
- **Slides 11-13** (Architecture/Scale): 3 minutes
- **Slides 14-19** (Benefits/ROI): 5 minutes
- **Slides 20-24** (Plan/Teams/Risks): 3 minutes
- **Slides 25-29** (Competitive/Future): 2 minutes
- **Slides 30-33** (Q&A/Close): 2 minutes

**Buffer**: Always have 5 minutes for unexpected questions

### For 15-minute version:
Use slides: 1, 2, 4, 6-10, 12, 17, 20, 31, 33

### For 5-minute version:
Use slides: 1, 2, 4, 10, 17, 31, 33

---

## Quick Start Commands

### Full Workflow

```bash
# Navigate to docs directory
cd /Users/chrishickey/datadog_pres/docs/

# Convert to PowerPoint
pandoc PRESENTATION_SLIDES.md -o presentation.pptx

# Open in default viewer (macOS)
open presentation.pptx

# Or if you have LibreOffice
libreoffice presentation.pptx

# Upload to Google Drive
# Then import into Google Slides via web interface
```

---

## Troubleshooting

### Pandoc not found
```bash
# Install via Homebrew (macOS)
brew install pandoc

# Or download installer
# https://pandoc.org/installing.html
```

### Formatting issues after import
- Use "Clear formatting" in Google Slides
- Reapply consistent theme
- Manually adjust bullet points if needed

### Slides too text-heavy
- Break content into multiple slides
- Use more bullet points, less paragraphs
- Add visual elements (icons, diagrams)
- Use speaker notes for details

### Table formatting lost
- Recreate tables in Google Slides
- Or import as images
- Consider using bullet points instead

---

## Additional Resources

### Presentation Best Practices
- One main idea per slide
- Use visuals over text when possible
- Practice timing with a timer
- Have backup plan if demo fails

### Google Slides Tips
- Use "Explore" feature for design ideas
- Add animations sparingly
- Test on projector/large screen
- Export as PDF for backup

### Demo Preparation
- Test demo in advance
- Have screenshots ready
- Clear browser history/tabs
- Use incognito mode for clean demo

---

## Need Help?

If you have issues converting or importing:

1. **Check Pandoc version**: `pandoc --version` (need 2.0+)
2. **Try online converter**: CloudConvert.com
3. **Manual import**: Copy content slide-by-slide
4. **Ask for help**: Slack #datadog-deployment

---

## Next Steps

1. ✅ Convert slides: `pandoc PRESENTATION_SLIDES.md -o presentation.pptx`
2. ✅ Import to Google Slides
3. ✅ Customize with branding
4. ✅ Add demo screenshots
5. ✅ Practice presentation
6. ✅ Schedule demo
7. ✅ Present with confidence!

Good luck! 🚀
