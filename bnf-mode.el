;;; bnf-mode.el --- Major mode for editing BNF grammars -*- lexical-binding: t; -*-

;; Copyright (C) 2017-2019 Serghei Iakovlev

;; Author: Serghei Iakovlev (concat "sadhooklay" "@" "gmail" ".com")
;; Maintainer: Serghei Iakovlev
;; Version: 0.1.0
;; URL: https://github.com/sergeyklay/bnf-mode
;; Keywords: languages
;; Package-Requires: ((cl-lib "0.5") (pkg-info "0.4") (emacs "24.3"))

;; This file is not part of GNU Emacs.

;;; License

;; This file is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;; Commentary:

;;   GNU Emacs major mode for editing BNF grammars.  Currently this mode
;; provides basic syntax and font-locking for "*.bnf" files.
;;
;; Usage:  Put this file in your Emacs Lisp path (eg. site-lisp) and add to
;; your .emacs file:
;;
;;   (require 'bnf-mode)
;;
;; Bugs: Bug tracking is currently handled using the GitHub issue tracker at
;; https://github.com/sergeyklay/bnf-mode/issues
;;
;; History: History is tracked in the Git repository rather than in this file.
;; See https://github.com/sergeyklay/bnf-mode/blob/master/CHANGELOG.org

;;; Code:


;;; Compatibility

;; Work around emacs bug#18845, cc-mode expects cl to be loaded
;; while zephir-mode only uses cl-lib (without compatibility aliases)
(eval-and-compile
  (if (and (= emacs-major-version 24) (>= emacs-minor-version 4))
      (require 'cl)))


;;; Requirements

;; Tell the byte compiler about autoloaded functions from packages
(declare-function pkg-info-version-info "pkg-info" (package))

(require 'cl-lib)
(require 'pkg-info)


;;; Customization

;;;###autoload
(defgroup zephir nil
  "Major mode for editing BNF grammars."
  :tag "BNF"
  :prefix "bnf-"
  :group 'languages
  :link '(url-link :tag "GitHub Page" "https://github.com/sergeyklay/bnf-mode")
  :link '(emacs-commentary-link :tag "Commentary" "bnf-mode"))

(defcustom bnf-mode-hook nil
  "List of functions to call when entering BNF Mode."
  :tag "Hook"
  :type 'hook
  :group 'bnf)


;;; Version information

(defun zephir-mode-version (&optional show-version)
  "Display string describing the version of BNF Mode.

If called interactively or if SHOW-VERSION is non-nil, show the
version in the echo area and the messages buffer.

The returned string includes both, the version from package.el
and the library version, if both a present and different.

If the version number could not be determined, signal an error,
if called interactively, or if SHOW-VERSION is non-nil, otherwise
just return nil."
  (interactive (list t))
  (let ((version (pkg-info-version-info 'zephir-mode)))
    (when show-version
      (message "BNF Mode version: %s" version))
    version))

(defvar bnf-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?#  "<" table)
    (modify-syntax-entry ?\n ">" table)
    table)
  "Syntax table in use in `bnf-mode' buffers.")


;;; Initialization

(define-derived-mode bnf-mode prog-mode "BNF"
  "A major mode for editing BNF grammars."
  :group 'bnf-mode
  ;; Comment setup
  (setq-local comment-use-syntax t)
  (setq-local comment-auto-fill-only-comments t)
  (setq-local comment-start "# ")
  (setq-local comment-end ""))

;; Invoke bnf-mode when appropriate

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.bnf\\'" . bnf-mode))

(provide 'bnf-mode)

;; Local Variables:
;; firestarter: ert-run-tests-interactively
;; End:

;;; bnf-mode.el ends here
