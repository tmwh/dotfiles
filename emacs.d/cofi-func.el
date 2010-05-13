(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(defun recentf-ido-find-file ()
  "Find a recent file using Ido."
  (interactive)
  (let* ((file-assoc-list
          (mapcar (lambda (x)
                    (cons (file-name-nondirectory x)
                          x))
                  recentf-list))
         (filename-list
          (remove ".ido.last"
                  (remove-duplicates (mapcar #'car file-assoc-list)
                                     :test #'string=)))
         (filename (ido-completing-read "Choose recent file: "
                                        filename-list
                                        nil
                                        t)))
    (when filename
      (find-file (cdr (assoc filename
                             file-assoc-list))))))

(defun ac-flyspell-prog-mode ()
  "Activate Flyspell prog mode and call ac workaround."
  (interactive)
  (flyspell-prog-mode)
  (ac-flyspell-workaround))

(defun ac-flyspell-mode ()
  "Activate Flyspell mode and call ac workaround."
  (interactive)
  (flyspell-mode 1)
  (ac-flyspell-workaround))

(defun increment-number-at-point (&optional amount)
  "Increment the number under point by `amount'"
  (interactive "p")
  (let ((num (number-at-point)))
    (when (numberp num)
      (let ((newnum (+ num amount))
         (p (point)))
    (save-excursion
      (skip-chars-backward "-.0123456789")
      (delete-region (point) (+ (point) (length (number-to-string num))))
      (insert (number-to-string newnum)))
    (goto-char p)))))

(defun decrement-number-at-point (&optional amount)
  (interactive "p")
  "Decrement the number under point by `amount'"
  (increment-number-at-point (- (abs amount))))

(provide 'cofi-func)