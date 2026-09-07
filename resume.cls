%%
%% Copyright (c) 2018-2024 Weitian LI
%% Copyright (c) 2016 Christophe Roger
%% The LaTeX Project Public License (LPPL) Version 1.3c
%%
%% Resume LaTeX template.
%% Based on
%%     YACC: Another Awesome CV by Christophe Roger
%%     https://github.com/darwiin/yaac-another-awesome-cv
%% which is further based on
%%     Plasmati Graduate CV by Alessandro Plasmati
%%     https://www.latextemplates.com/template/plasmati-graduate-cv
%%

\ProvidesClass{resume}[2024/12/06 v3.0.0 Resume Class]
\LoadClass{article}

%%
%% Class options
%%
%%   monochrome -- render everything in black
%%   zh         -- Chinese typesetting (xeCJK + Noto Sans CJK SC)
%%   compact    -- tight one-page geometry, 9pt type scale, dense rhythm
%%

\DeclareOption{monochrome}{\def\@monochrome{true}}
\DeclareOption{zh}{\def\@zh{true}}
\DeclareOption{compact}{\def\@compact{true}}
\ProcessOptions\relax

%%
%% Packages
%%

\RequirePackage[%
  a4paper,%
  margin=1.5cm,%
  includefoot,%
]{geometry}
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage{fontspec}
\RequirePackage{fontawesome5}
\RequirePackage{parskip}  % auto adjust parskip and items skip
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{setspace}
\RequirePackage{array}
\RequirePackage{multirow}
\RequirePackage{makecell}  % multirowcell
\RequirePackage{longtable}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{tikz}
\RequirePackage[skins]{tcolorbox}  % required by tikz to make the header
\RequirePackage{csquotes}
\RequirePackage{relsize}  % relatively scale the icons
\RequirePackage{keyval}  % key=value style parameters
\RequirePackage{graphicx}  % organisation logos
\ifdef{\@zh}{
  \RequirePackage{xeCJK}
}{}
\RequirePackage{microtype}

% Compact page geometry: shorter measure than the original 1.5cm so the
% text block does not run edge-to-edge, plus tighter head/foot margins.
\ifdef{\@compact}{
  \geometry{hmargin=1.25cm, top=1.0cm, bottom=0.75cm, includefoot}
}{}

%
% Hyperref
%
% Delay the execution of \hypersetup at \begin{document}.
% NOTE: Should be set before hyperref uses it.
\AtBeginDocument{%
  \hypersetup{%
    pdfborder={0 0 0},% No border around links
    pdfauthor={\@name},%
    pdftitle={%
      \ifdef{\@zh}{简历 | \@name}{Resume | \@name}%
      \ifdef{\@tagline}{ | \@tagline}{}%
    },%
    pdfkeywords={\ifdef{\@keywords}{\@keywords}{}},%
  }%
}
\RequirePackage{hyperref}

%%
%% Fonts
%%
%% Serif throughout: IBM Plex Serif + Noto Serif CJK SC.  Mono is reserved
%% for code identifiers.
%%

\defaultfontfeatures{Mapping=tex-text}
\setmainfont{IBM Plex Serif}
\setmonofont{IBM Plex Mono}[Scale=0.9]

% Tabular lining figures, so the stacked date rail aligns column-perfect.
\newfontfamily{\datefont}{IBM Plex Serif}[Numbers={Monospaced,Lining}]

% Chinese setup
\ifdef{\@zh}{
  \setCJKmainfont{Noto Serif CJK SC}
  % Redefine '\emph' to bold style
  % Credit: https://tex.stackexchange.com/a/227644
  \let\emph\relax  % there's no \RedeclareTextFontCommand
  \DeclareTextFontCommand{\emph}{\bfseries}
}{}

%%
%% Type scale
%%
%% 'article' only offers 10/11/12pt, and mixing \fontsize with the built-in
%% \small / \footnotesize leaves the relative sizes incoherent (that is what
%% made the old compact overrides drift).  So redefine the whole ladder once.
%%
%% The steps are deliberately wide -- name / section / entry title / body /
%% meta each land on a clearly different size, so hierarchy carries the page
%% instead of weight alone.
%%

\ifdef{\@compact}{
  \renewcommand{\normalsize}{\fontsize{9}{11.9}\selectfont}
  \renewcommand{\small}{\fontsize{8.3}{10.8}\selectfont}
  \renewcommand{\footnotesize}{\fontsize{7.7}{9.5}\selectfont}
  \renewcommand{\scriptsize}{\fontsize{7}{8.8}\selectfont}
  \renewcommand{\tiny}{\fontsize{6.2}{7.6}\selectfont}
  \renewcommand{\large}{\fontsize{10.5}{13}\selectfont}
  \renewcommand{\Large}{\fontsize{13}{15.5}\selectfont}
  \renewcommand{\LARGE}{\fontsize{16}{19}\selectfont}
  \renewcommand{\huge}{\fontsize{23}{26}\selectfont}
  \renewcommand{\Huge}{\fontsize{27}{30}\selectfont}
  \linespread{1}
}{}

%%
%% Colours
%%

\ifdef{\@monochrome}{
  \definecolor{basecolor}{HTML}{000000}
  \definecolor{inkcolor}{HTML}{000000}
  \definecolor{mutedcolor}{HTML}{4A4A4A}
  \definecolor{hairlinecolor}{HTML}{B4B4B4}
}{
  \definecolor{basecolor}{HTML}{000066}     % deep blue
  \definecolor{inkcolor}{HTML}{1B1D21}     % body text, softer than pure black
  \definecolor{mutedcolor}{HTML}{5C5C70}   % dates, meta, summaries
  \definecolor{hairlinecolor}{HTML}{C7C7D6} % rules
}
\colorlet{linkcolor}{basecolor}
\colorlet{accentcolor}{linkcolor!90}
\colorlet{symbolcolor}{linkcolor!85}

% Font Awesome icon aliases
\newcommand*{\birthdaySymbol}{\faBirthdayCake}
\newcommand*{\degreeSymbol}{\faGraduationCap}
\newcommand*{\githubSymbol}{\faGithub}
\newcommand*{\homeSymbol}{\faHome}
\newcommand*{\infoSymbol}{\faInfoCircle}
\newcommand*{\mailSymbol}{\faAt}
\newcommand*{\mobileSymbol}{\faPhone}  % \faMobilePhone is too narrow
\newcommand*{\linkedinSymbol}{\faLinkedin}
\newcommand*{\locationSymbol}{\faMapMarker*}
\newcommand*{\phoneSymbol}{\faPhone}
\newcommand*{\universitySymbol}{\faUniversity}

% Date format: yyyy.mm.dd
\newcommand*{\twodigits}[1]{\ifnum#1<10 0\fi\the#1}
\renewcommand*{\today}{%
  \leavevmode\hbox{\the\year.\twodigits\month.\twodigits\day}
}

% Non-numbered pages
\pagestyle{empty}

% Last-page style
\def\ps@lastpage{%
  \def\@oddfoot{\textcolor{mutedcolor}{\footnotesize\@fileinfo}\hfil}%
  \def\@evenfoot{\textcolor{mutedcolor}{\footnotesize\@fileinfo}\hfil}%
}
\AtEndDocument{\thispagestyle{lastpage}}

% No paragraph indentation
\setlength{\parindent}{0em}

% Line spacing
\ifdef{\@compact}{}{%
  \ifdef{\@zh}{\linespread{1.25}}{\linespread{1.15}}%
}

% Apply the body size/colour once the document starts.
\AtBeginDocument{\normalsize\color{inkcolor}}

%%
%% Semantic text styles
%%

\newcommand*{\datestyle}{\datefont\small\color{mutedcolor}}
\newcommand*{\asidestyle}{\normalfont\small\color{mutedcolor}}
\newcommand*{\summarystyle}{\normalfont\small\color{mutedcolor}}
% Entry titles sit a full step above the body so they read as headings.
\ifdef{\@compact}%
  {\newcommand*{\entrytitlestyle}{%
     \fontsize{10.5}{12.6}\selectfont\bfseries\color{basecolor}}}%
  {\newcommand*{\entrytitlestyle}{\bfseries\color{basecolor}}}
\ifdef{\@compact}%
  {\newcommand*{\sectionfont}{\fontsize{13}{15.5}\selectfont\bfseries}}%
  {\newcommand*{\sectionfont}{\Large\bfseries}}

%%
%% Sections
%%
%% A compact left-aligned label followed by a hairline that runs to the right
%% margin -- reads as one line instead of the old oversized title stacked on
%% top of a full-width rule.
%%

\titleformat{\section}[block]%
  {\normalfont\sectionfont\color{basecolor}%
   \rightskip=0pt\relax\parfillskip=0pt\relax}%
  {}{0em}{}
\titlespacing*{\section}{0em}{2.4ex}{1.2ex}

\newcommand*{\sectionrule}{%
  \nobreak\hspace{0.6em}%
  {\color{hairlinecolor}\leaders\hrule height 1.3pt depth -0.75pt \hfill}%
  \kern0pt%
}

% Title: \sectionTitle{<label>}{<icon>}
\newcommand*{\sectionTitle}[2]{%
  \section{%
    \texorpdfstring%
      {\icon[\relsize{-1}]{#2}#1\sectionrule}%
      {#1}%
  }%
}

%%
%% Column grid
%%
%% One narrow left rail (dates / labels) plus the content column.  The rail
%% and the gutter are the only horizontal structure -- no vertical rules,
%% which is what made entries without a date look broken.
%%

\newlength{\leftcolwidth}
\newlength{\rightcolwidth}
\newlength{\entrygutter}
\setlength{\entrygutter}{1.15em}
\ifdef{\@zh}{%
  \ifdef{\@compact}{\setlength{\leftcolwidth}{4.3em}}%
                   {\setlength{\leftcolwidth}{6em}}%
}{
  \setlength{\leftcolwidth}{8.1em}
}

% \rightcolwidth must be recomputed whenever \leftcolwidth changes, and it
% must follow \linewidth so the grid also works inside a minipage.
\newcommand*{\@setcolwidths}{%
  \setlength{\rightcolwidth}{%
    \dimexpr \linewidth - \leftcolwidth - \entrygutter \relax}%
}
\AtBeginDocument{\@setcolwidths}

% Set the rail width and refresh the content width in one go.
\newcommand*{\railwidth}[1]{%
  \setlength{\leftcolwidth}{#1}%
  \@setcolwidths%
}

% Two-column entry preamble shared by every entry environment.  It has to be
% a \newcolumntype: 'array' expands column types while parsing a preamble,
% but not arbitrary macros.
\newcolumntype{E}{%
  @{}R{\leftcolwidth}@{\hspace{\entrygutter}}L{\rightcolwidth}@{}%
}

%%
%% Generic commands
%%

\newcommand*{\creativecommons}[2]{%
  \href{https://creativecommons.org/licenses/#1/#2/}%
    {\faCreativeCommons{} \uppercase{#1} #2}%
}

\newcommand*{\githublink}[2]{%
  \href{https://github.com/#1/#2}{\githubSymbol{} #1/#2}%
}

\newcommand*{\link}[2]{\textcolor{linkcolor}{\href{#1}{#2}}}

%%
%% Organisation logos
%%
%% Real (colour) brand marks kept under 'assets/' as small square PNGs, drawn
%% at roughly the cap height of the entry title so they read as part of the
%% line rather than as floating images.  The optical drop keeps the mark's
%% centre on the text's visual centre instead of on the baseline.
%%

\newcommand*{\logoheight}{1.05em}
\newcommand*{\logodrop}{-0.2em}
\newcommand*{\logogutter}{0.42em}

% Bare logo: \orglogo[<height>]{<file>}
\NewDocumentCommand{\orglogo}{O{\logoheight}m}{%
  \raisebox{\logodrop}{\includegraphics[height=#1]{#2}}%
}

% Logo + linked organisation name, kept unbreakable:
%   \orgtitle[<height>]{<file>}{<url>}{<name>}
\NewDocumentCommand{\orgtitle}{O{\logoheight}mmm}{%
  \mbox{%
    \orglogo[#1]{#2}\hspace{\logogutter}%
    \href{#3}{\textcolor{basecolor}{#4}}%
  }%
}

% The scale step for icons.
% A positive step to enlarge icons, and a negative step to reduce them.
\def\@iconscale{1}
\newcommand*{\iconscale}[1]{\def\@iconscale{#1}}

% Icon: \icon[size]{\faICON}
\NewDocumentCommand{\icon}{om}{
  {\IfValueTF{#1}{#1}{\relsize{\@iconscale}}%
   \makebox[0.95em][c]{\textcolor{symbolcolor}{#2}}}%
  \hspace{0.2em}\strut%
}

% Test whether the command argument is given and is not empty
% Credit: https://tex.stackexchange.com/a/63233
\ExplSyntaxOn
\DeclareExpandableDocumentCommand{\IfNoValueOrEmptyTF}{mmm}{%
  \IfNoValueTF{#1}{#2}{%
    \tl_if_empty:nTF {#1} {#2} {#3}
  }
}
\ExplSyntaxOff

% Hairline across the current measure
\newcommand*{\hairline}[1][0.6pt]{%
  \par\noindent\textcolor{hairlinecolor}{\rule{\linewidth}{#1}}\par%
}

% Vertical gap between two adjacent entry blocks
\newcommand*{\entrygap}{\par\vspace{1.4ex}}

% "present" / "至今"
\newcommand*{\@presentword}{\ifdef{\@zh}{至今}{Present}}

%%
%% Tags
%%
%% Outlined pills, as in the original design, but drawn in the current
%% palette rather than the old blue.
%%

\newcommand*{\tagfont}{\footnotesize}

% Create a tag: \tag{<label>}
\newcommand*{\tag}[1]{%
  \tikz[baseline]
  \node[anchor=base,
        draw=accentcolor!45,
        text=basecolor!88,
        rounded corners=0.5ex,
        inner xsep=0.8ex,
        inner ysep=0.5ex,
        text height=1.6ex,
        text depth=0.4ex]{\tagfont #1};%
}

\newcommand*{\tags}[1]{%
  \icon{\faTags}%
  \foreach \n in {#1}{\tag{\n}\hspace{0.1em}}%
}

%%
%% Position and location
%%

\newcommand*{\setposition}[1]{\def\@position{#1}}
\newcommand*{\getposition}{\@position}
\newcommand*{\setlocation}[1]{\def\@location{#1}}
\newcommand*{\getlocation}{\@location}

%%
%% Header
%%

% Separator placed *before* each profile item, so a right-aligned profile
% block still ends flush against the right margin.
\newcommand*{\profilesep}{\hspace{1.0em}}

% Type size of the contact block.  It sits a hair *above* body size: the
% header is the first thing read, and the width bought by a narrow
% \headersplit is spent on legibility instead of white space.  10pt is the
% ceiling -- past it the phone/wechat/mail line wraps to a fourth row.
\newcommand*{\profilestyle}{\fontsize{10}{13}\selectfont}

% Emphasis inside the contact block, for the channels you want read first.
\newcommand*{\profilehl}[1]{\textbf{#1}}

% Render a text with its icon
% Usage: \icontext{<icon>}{<label>}
\newcommand*{\icontext}[2]{%
  \profilesep\mbox{\icon{#1} #2}%
}

% Render a link with its icon and text
% Usage: \iconlink{<icon>}{<link>}{<text>}
\newcommand*{\iconlink}[3]{%
  \profilesep\mbox{\icon{#1} \link{#2}{#3}}%
}

% Name: \name{<firstname>}{<lastname>}
\newcommand*{\name}[2]{
  \def\@firstname{#1}
  \def\@lastname{#2}
  \def\@name{%
    \ifdef{\@zh}%
      {\@lastname\@firstname}%
      {\textsc{\@firstname} \@lastname}%
  }
}
% Tag line
\newcommand*{\tagline}[1]{\def\@tagline{#1}}
% Keywords
\newcommand*{\keywords}[1]{\def\@keywords{#1}}
% File information
\newcommand*{\fileinfo}[1]{\def\@fileinfo{#1}}

% Photo:
% \photo[
%   shape=<circular|square>,    % default is circular
%   position=<left|right>,      % default is left
% ]{<width>}{<filename>}
\define@key{photo}{shape}{\def\@photo@shape{#1}}
\define@key{photo}{position}{\def\@photo@position{#1}}
\NewDocumentCommand{\photo}{
  O{shape=circular, position=left}
  m m
}{
  \setkeys{photo}{#1}
  \def\@photo@width{#2}
  \def\@photo{%
    \begin{minipage}{\@photo@width}
      \ifdefstring{\@photo@shape}{square}{%
        \tikz\path[fill overzoom image={#3}]
          rectangle (\linewidth, \linewidth);% (suppress blank)
      }{%
        \tikz\path[fill overzoom image={#3}]
          circle[radius=0.5\linewidth];% (suppress blank)
      }%
    \end{minipage}% (suppress blank)
  }
}

% Address
\newcommand*{\address}[1]{\icontext{\locationSymbol}{#1}}
% Birthday
\newcommand*{\birthday}[1]{\icontext{\birthdaySymbol}{#1}}
% Place of birth
\newcommand*{\home}[1]{\icontext{\homeSymbol}{#1}}
% Information
\newcommand*{\info}[1]{\icontext{\infoSymbol}{#1}}
% Mobile phone
\newcommand*{\mobile}[1]{\icontext{\mobileSymbol}{#1}}
% Phone
\newcommand*{\phone}[1]{\icontext{\phoneSymbol}{#1}}
% Degree
\newcommand*{\degree}[1]{\icontext{\degreeSymbol}{#1}}
% University
\newcommand*{\university}[1]{\icontext{\universitySymbol}{#1}}

% LinkedIn: \linkedin{<username>}
\newcommand*{\linkedin}[1]{%
  \iconlink{\linkedinSymbol}%
    {https://www.linkedin.com/in/#1}%
    {linkedin.com/in/#1}%
}
% GitHub: \github{<username>}
\newcommand*{\github}[1]{%
  \iconlink{\githubSymbol}%
    {https://github.com/#1}%
    {\texttt{github.com/#1}}%
}
% Email address
\newcommand*{\email}[1]{%
  \iconlink{\mailSymbol}{mailto:#1}{\texttt{#1}}%
}

% Define the profile to show in the header
\newcommand*{\profile}[1]{\def\@profile{#1}}

% Width of the name block in the two-column header
\newcommand*{\headersplit}[1]{\def\@headersplit{#1}}
\headersplit{0.40}

% Render resume header: name/tagline on the left, contact block flush right.
% Stacking them side by side saves two lines over the old full-width layout
% and gives the page a proper masthead.
\newcommand*{\makeheader}{%
  \ifdef{\@photo}{%
    \def\@header@width{\dimexpr \linewidth - \@photo@width - 1em\relax}%
  }{%
    \def\@header@width{\linewidth}%
  }%
  \noindent
  \ifdef{\@photo}{%
    \ifdefstring{\@photo@position}{right}{}{\@photo\hspace{1em}}%
  }{}%
  \begin{minipage}[b]{\dimexpr \@headersplit\@header@width\relax}
    \raggedright
    {\huge\bfseries\color{basecolor}\@name}%
    \ifdef{\@tagline}{%
      \\[0.7ex]
      {\large\color{mutedcolor}\@tagline}%
    }{}%
  \end{minipage}%
  \hfill
  \begin{minipage}[b]{\dimexpr \@header@width - \@headersplit\@header@width - 1em\relax}
    \raggedleft\profilestyle
    \@profile
  \end{minipage}%
  \ifdef{\@photo}{%
    \ifdefstring{\@photo@position}{right}{\hfill\@photo}{}%
  }{}%
  \par\vspace{0.85ex}%
  \hairline%
}

%%
%% Abstract
%%
%% A thin accent bar on the left marks the summary without costing a line.
%%

\RenewDocumentEnvironment{abstract}{}{%
  \phantomsection
  \addcontentsline{toc}{section}{\ifdef{\@zh}{摘要}{Abstract}}
  \par\vspace{0.5ex}
  \begin{tcolorbox}[blanker,
      borderline west={1.7pt}{0pt}{basecolor!28},
      left=0.75em, right=0pt, top=0.25ex, bottom=0.25ex]%
}{%
  \end{tcolorbox}%
  \par\vspace{0.1ex}%
}

%%
%% Entry building blocks
%%

% Extra array column types
% Credit: https://tex.stackexchange.com/a/12712
\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}

% Stacked date range in the left rail: start on top, end below.
% The first line stays in the normal flow so it shares the row's baseline;
% the second is a zero-size overlay dropped one line, so a two-line date
% never inflates the title row.  (Putting *both* lines in a zeroed box moves
% the cell's reference point to its top edge and the whole rail slips down a
% line -- which is exactly what went wrong before.)
\newcommand*{\daterange}[2]{%
  {\datestyle #1%
   \raisebox{0pt}[0pt][0pt]{%
     \makebox[0pt][r]{%
       \raisebox{-\baselineskip}[0pt][0pt]{\datestyle\textendash#2}%
     }%
   }%
  }%
}

% Push the rest of the title line flush right as muted meta text.
% \rightskip/\parfillskip are read at \par time, so setting them here is
% enough to turn just this line flush-both.
\newcommand*{\aside}[1]{%
  \unskip\hspace{0.9em}\nobreak\hfill\nobreak
  \mbox{\asidestyle #1}%
  \rightskip=0pt\relax\parfillskip=0pt\relax%
}

% Entry title, optionally carrying an \aside{...}.
% Deliberately neither grouped nor \par-terminated: an explicit \par inside a
% p-column cell pushes the column's \@finalstrut into a *second* paragraph,
% which costs a full blank line under every entry title.  Leaving the cell to
% end its own paragraph also lets \aside's \rightskip/\parfillskip survive
% until that \par, which is when TeX actually reads them.
\newcommand*{\entrytitle}[1]{\entrytitlestyle #1}

% Separator (extra vertical space) between two entries
\newcommand*{\separator}[1]{\noalign{\vskip #1}}

%%
%% Section: entries (generic label + content grid)
%%

% \begin{entries}[<rail-width>]
\NewDocumentEnvironment{entries}{o}{%
  \IfValueTF{#1}{\railwidth{#1}}{\@setcolwidths}%
  \begin{tabular}[t]{E}%
}{%
  \end{tabular}
}

\NewDocumentCommand{\entry}{m m}{
  #1 & \begin{minipage}[t]{\rightcolwidth} #2 \end{minipage} \\
}

%%
%% Section: competences
%%

% \begin{competences}[<label-width>]
\NewDocumentEnvironment{competences}{o}{%
  \IfValueTF{#1}{\railwidth{#1}}{\@setcolwidths}%
  \renewcommand{\arraystretch}{1.0}%
  \begin{tabular}[t]{E}%
}{%
  \end{tabular}
}

\NewDocumentCommand{\comptence}{m m}{
  {\bfseries\color{basecolor!88}\small #1} & #2 \\
}

%%
%% Section: educations
%%

\NewDocumentEnvironment{educations}{}{%
  \@setcolwidths
  \begin{tabular}[t]{E}%
}{%
  \end{tabular}
}

% \education
%   {<start-date>}  % #1
%   [<end-date>]    % #2
%   {<school>}      % #3
%   {<department>}  % #4
%   {<major>}       % #5
%   {<degree>}      % #6
\NewDocumentCommand{\education}{m o m m m m}{
  \daterange{#1}{\IfValueTF{#2}{#2}{\@presentword}}
  \ifdef{\@zh}{%
    & \entrytitle{#3\aside{#4}} \\*
    & {\summarystyle #5 \textbullet\ #6} \\
  }{%
    & \entrytitle{#3\aside{#4}} \\*
    & {\summarystyle #6 in #5} \\
  }
}

%%
%% Section: projects
%%

\NewDocumentEnvironment{projects}{}{%
  \@setcolwidths
  \setlength{\LTpre}{0pt}%
  \setlength{\LTpost}{0pt}%
  \renewcommand{\arraystretch}{0.98}%
  \begin{longtable}{E}%
}{%
  \end{longtable}
}

% \project
%   {<start-date>}   % #1
%   [<end-date>]     % #2
%   {<department>}   % #3
%   {<type>}         % #4
%   {<name>}         % #5
%   [<summary>]      % #6
%   {<description>}  % #7
%   [<tags>]         % #8
\NewDocumentCommand{\project}{m o m m m o m o}{
  \IfNoValueOrEmptyTF{#1}{}{%
    \daterange{#1}{\IfValueTF{#2}{#2}{\@presentword}}%
  }
  & \entrytitle{#5\aside{\ifdef{\@zh}{#3 \textbullet\ #4}{#4, #3}}} \\*
  \noalign{\vskip 0.5ex}%
  \IfValueT{#6}{%
    & {\summarystyle #6} \\*
    \noalign{\vskip 0.35ex}%
  }
  & \begin{minipage}[t]{\rightcolwidth} #7 \end{minipage} \\*
  \IfValueT{#8}{%
    \noalign{\vskip 0.35ex}%
    & {\tags{#8}} \\
  }
}

%%
%% Section: experiences
%%

\NewDocumentEnvironment{experiences}{}{%
  \@setcolwidths
  \setlength{\LTpre}{0pt}%
  \setlength{\LTpost}{0pt}%
  \renewcommand{\arraystretch}{0.98}%
  \begin{longtable}{E}%
}{%
  \end{longtable}
}

% \experience
%   [<start-date>]   % #1
%   {<end-date>}     % #2
%   {<summary>}      % #3
%   [<description>]  % #4
%   [<tags>]         % #5
\NewDocumentCommand{\experience}{o m m o o}{
  \IfValueTF{#1}{\daterange{#1}{#2}}{{\datestyle #2}}
  & \entrytitle{#3} \\*
  \noalign{\vskip 0.5ex}%
  \IfNoValueOrEmptyTF{#4}{}{%
     & \begin{minipage}[t]{\rightcolwidth}
         #4
       \end{minipage} \\*
  }
  \IfValueT{#5}{%
    \noalign{\vskip 0.35ex}%
    & {\tags{#5}} \\
  }
}

%%
%% Two-column section
%%

\newcommand*{\twocolumnsection}[2]{%
  \noindent
  \begin{minipage}[t]{\dimexpr 0.5\linewidth - 0.7em\relax}
    #1
  \end{minipage}%
  \hfill
  \begin{minipage}[t]{\dimexpr 0.5\linewidth - 0.7em\relax}
    #2
  \end{minipage}%
}

%%
%% Section: skills
%%

\NewDocumentEnvironment{skills}{}{%
  \@setcolwidths
  \begin{tabular}[t]{E}%
}{%
  \end{tabular}
}

\NewDocumentCommand{\skill}{m m}{
  {\bfseries\color{basecolor!88}\small #1} &
    \foreach \x in {1,...,5}{%
      \color{accentcolor!80}{%
        \ifnumgreater{\x}{#2}{\faCircleNotch}{\faCircle}
      }
    } \enspace \\
}

%%
%% Section: referees
%%

\newenvironment{referees}{%
}{%
  \hfill
  \bigskip
}

\newcommand*{\referee}[5]{%
  \hspace{1em}
  \begin{minipage}[t]{\dimexpr(\linewidth/3) - 3em}
    \begin{tabular}{>{}l >{}l}
      \multicolumn{2}{l}{\textbf{#1}}\\
      \multicolumn{2}{l}{\emph{#2}, \textsc{#3}}\\
      \quad \mailSymbol & \href{mailto:#4}{#4} \\
      \quad \phoneSymbol & #5 \\
    \end{tabular}
  \end{minipage}%
}

%%
%% Lists
%%

\setlist[itemize,1]{%
  label=\textcolor{basecolor!75}{\faAngleRight},
  nosep,
  itemsep=0.32ex,
  leftmargin=1.4em,
  labelsep=0.42em,
}
\setlist[description,1]{style=sameline}

\endinput
%% EOF
