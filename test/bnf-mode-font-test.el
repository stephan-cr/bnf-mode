;;; bnf-mode-font-test.el --- BNF Mode: Font highlighting test suite -*- lexical-binding: t; -*-

;; Copyright (C) 2019 Serghei Iakovlev

;; Author: Serghei Iakovlev (concat "sadhooklay" "@" "gmail" ".com")
;; Maintainer: Serghei Iakovlev
;; Version: 0.2.0
;; URL: https://github.com/sergeyklay/bnf-mode

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

;;   Automate tests from the "test" directory using `ert', which comes bundled
;; with Emacs >= 24.1.

;;; Code:


;;;; Utilities

(defun bnf-test-face-at (pos &optional content)
  "Get the face at POS in CONTENT.

If CONTENT is not given, return the face at POS in the current
buffer."
  (if content
      (bnf-test-with-temp-buffer content
                                 (get-text-property pos 'face))
    (get-text-property pos 'face)))


;;;; Font locking

(ert-deftest bnf-mode-syntax-table/fontify-strings ()
  :tags '(fontification syntax-table)
  (should (eq (bnf-test-face-at 11 "<foo> ::= \"bar\"") 'font-lock-string-face)))

(ert-deftest bnf-mode-syntax-table/fontify-line-comment ()
  :tags '(fontification syntax-table)
  (bnf-test-with-temp-buffer "; A

<stm> ::= <decl> ; foo"
                             (should (eq (bnf-test-face-at 1) 'font-lock-comment-face))
                             (should (eq (bnf-test-face-at 3) 'font-lock-comment-face))
                             (should-not (bnf-test-face-at 5))
                             (should (eq (bnf-test-face-at 24) 'font-lock-comment-face))))

(ert-deftest bnf-mode-syntax-table/fontify-nonterminals ()
  :tags '(fontification syntax-table)
  (bnf-test-with-temp-buffer "<stm> ::= <decl>"
                             ;; angle bracket
                             (should-not (bnf-test-face-at 1))
                             ;; "stm"
                             (should (eq (bnf-test-face-at 2) 'font-lock-function-name-face))
                             (should (eq (bnf-test-face-at 4) 'font-lock-function-name-face))
                             ;; angle bracket
                             (should-not (bnf-test-face-at 5))
                             ;; "may expand into" symbol
                             (should-not (eq (bnf-test-face-at 7) 'font-lock-function-name-face))
                             ;; angle bracket
                             (should-not (bnf-test-face-at 11))
                             ;; "dec" symbol
                             (should-not (eq (bnf-test-face-at 12) 'font-lock-function-name-face))
                             (should-not (eq (bnf-test-face-at 15) 'font-lock-function-name-face))))

(provide 'bnf-mode-font-test)

;;; bnf-mode-font-test.el ends here