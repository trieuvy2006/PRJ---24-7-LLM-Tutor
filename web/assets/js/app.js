/**
 * AITA — 24/7 LLM Tutor Platform
 * Global Frontend JavaScript Controller
 * Theme Manager, Sidebar Controls, Password Toggle, Modal Dialogs & Table Filtering
 */

(function () {
  'use strict';

  // 1. THEME MANAGER (Dark / Light with LocalStorage persistence)
  const THEME_KEY = 'aita_theme_pref';

  function initTheme() {
    const savedTheme = localStorage.getItem(THEME_KEY) || 'dark';
    document.documentElement.setAttribute('data-theme', savedTheme);
    updateThemeToggleIcons(savedTheme);
  }

  function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem(THEME_KEY, newTheme);
    updateThemeToggleIcons(newTheme);
  }

  function updateThemeToggleIcons(theme) {
    document.querySelectorAll('.btn-theme-toggle').forEach(btn => {
      const icon = btn.querySelector('i');
      if (icon) {
        if (theme === 'light') {
          icon.className = 'bi bi-moon-stars-fill';
          btn.setAttribute('aria-label', 'Chuyển sang chế độ tối');
          btn.title = 'Chuyển sang chế độ tối';
        } else {
          icon.className = 'bi bi-sun-fill';
          btn.setAttribute('aria-label', 'Chuyển sang chế độ sáng');
          btn.title = 'Chuyển sang chế độ sáng';
        }
      }
    });
  }

  // 2. SIDEBAR CONTROLS (Collapse & Mobile Drawer)
  function toggleSidebar() {
    if (window.innerWidth <= 900) {
      document.body.classList.toggle('sidebar-mobile-open');
    } else {
      document.body.classList.toggle('sidebar-collapsed');
      const isCollapsed = document.body.classList.contains('sidebar-collapsed');
      localStorage.setItem('aita_sidebar_collapsed', isCollapsed ? 'true' : 'false');
    }
  }

  function initSidebarState() {
    if (window.innerWidth > 900) {
      const isCollapsed = localStorage.getItem('aita_sidebar_collapsed') === 'true';
      if (isCollapsed) {
        document.body.classList.add('sidebar-collapsed');
      }
    }
  }

  // 3. PASSWORD VISIBILITY TOGGLE
  function initPasswordToggles() {
    document.querySelectorAll('.btn-toggle-pass').forEach(btn => {
      btn.addEventListener('click', function (e) {
        e.preventDefault();
        const wrapper = this.closest('.input-wrapper');
        if (!wrapper) return;
        const input = wrapper.querySelector('input');
        const icon = this.querySelector('i');
        if (!input || !icon) return;

        if (input.type === 'password') {
          input.type = 'text';
          icon.className = 'bi bi-eye-slash-fill';
          this.setAttribute('aria-label', 'Ẩn mật khẩu');
        } else {
          input.type = 'password';
          icon.className = 'bi bi-eye-fill';
          this.setAttribute('aria-label', 'Hiển thị mật khẩu');
        }
      });
    });
  }

  // 4. FORM SUBMIT LOADING INDICATOR
  function initFormLoading() {
    document.querySelectorAll('form').forEach(form => {
      form.addEventListener('submit', function () {
        const submitBtn = this.querySelector('button[type="submit"]');
        if (submitBtn && !submitBtn.classList.contains('no-spin')) {
          submitBtn.classList.add('loading');
        }
      });
    });
  }

  // 5. LIVE CLIENT-SIDE TABLE SEARCH & FILTERING (For user.jsp)
  window.filterUserTable = function () {
    const searchInput = document.getElementById('tableSearchInput');
    const roleSelect = document.getElementById('tableRoleFilter');
    const tableBody = document.getElementById('userTableBody');
    const emptyState = document.getElementById('tableEmptyState');
    if (!tableBody) return;

    const searchTerm = (searchInput ? searchInput.value : '').toLowerCase().trim();
    const selectedRole = roleSelect ? roleSelect.value : '';

    const rows = tableBody.querySelectorAll('tr.user-row');
    let visibleCount = 0;

    rows.forEach(row => {
      const username = (row.dataset.username || '').toLowerCase();
      const fullname = (row.dataset.fullname || '').toLowerCase();
      const email = (row.dataset.email || '').toLowerCase();
      const roleId = row.dataset.roleId || '';

      const matchesSearch = !searchTerm ||
        username.includes(searchTerm) ||
        fullname.includes(searchTerm) ||
        email.includes(searchTerm);

      const matchesRole = !selectedRole || roleId === selectedRole;

      if (matchesSearch && matchesRole) {
        row.style.display = '';
        visibleCount++;
      } else {
        row.style.display = 'none';
      }
    });

    if (emptyState) {
      emptyState.style.display = visibleCount === 0 ? 'block' : 'none';
    }
  };

  // 6. DELETE CONFIRMATION MODAL
  let targetDeleteUrl = '';

  window.openDeleteModal = function (userId, username) {
    const modal = document.getElementById('deleteConfirmModal');
    const nameHolder = document.getElementById('deleteTargetName');
    const confirmBtn = document.getElementById('btnConfirmDelete');
    if (!modal) return;

    if (nameHolder) nameHolder.textContent = username;
    targetDeleteUrl = 'delete?user_id=' + encodeURIComponent(userId);
    modal.classList.add('show');
  };

  window.closeDeleteModal = function () {
    const modal = document.getElementById('deleteConfirmModal');
    if (modal) modal.classList.remove('show');
  };

  window.executeDelete = function () {
    if (targetDeleteUrl) {
      window.location.href = targetDeleteUrl;
    }
  };

  // Listen for escape key on modal
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
      closeDeleteModal();
    }
  });

  // 7. SIDEBAR USER ACCOUNT POPOVER MENU
  // 7. USER ACCOUNT MENU (TOPBAR & SIDEBAR DROPDOWN / POPOVER)
  function initUserMenuPopover() {
    function setupDropdown(wrapper, toggleBtn, dropdown) {
      if (!wrapper || !toggleBtn || !dropdown) return;

      let hoverTimeout;

      function openMenu() {
        clearTimeout(hoverTimeout);
        dropdown.classList.add('show');
        wrapper.classList.add('open');
        toggleBtn.setAttribute('aria-expanded', 'true');
      }

      function closeMenu() {
        dropdown.classList.remove('show');
        wrapper.classList.remove('open');
        toggleBtn.setAttribute('aria-expanded', 'false');
      }

      function toggleMenu() {
        if (dropdown.classList.contains('show')) {
          closeMenu();
        } else {
          openMenu();
        }
      }

      // Click toggle
      toggleBtn.addEventListener('click', function (e) {
        e.stopPropagation();
        toggleMenu();
      });

      // Hover on wrapper
      wrapper.addEventListener('mouseenter', function () {
        openMenu();
      });

      wrapper.addEventListener('mouseleave', function () {
        hoverTimeout = setTimeout(function () {
          closeMenu();
        }, 250);
      });

      // Close when clicking outside
      document.addEventListener('click', function (e) {
        if (!wrapper.contains(e.target)) {
          closeMenu();
        }
      });

      // Close on escape
      document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
          closeMenu();
        }
      });
    }

    // Topbar user menu
    const topbarWrapper = document.getElementById('topbarUserMenuWrapper');
    const topbarToggle = document.getElementById('btnTopbarUserToggle');
    const topbarDropdown = document.getElementById('topbarUserDropdown');
    setupDropdown(topbarWrapper, topbarToggle, topbarDropdown);

    // Sidebar user menu
    const sidebarContainer = document.querySelector('.sidebar-user-container');
    const sidebarToggle = document.getElementById('btnUserMenuToggle');
    const sidebarPopover = document.getElementById('sidebarUserPopover');
    setupDropdown(sidebarContainer, sidebarToggle, sidebarPopover);
  }

  // 8. SETTINGS MODAL CONTROLS
  window.openSettingsModal = function () {
    const modal = document.getElementById('settingsModal');
    if (modal) {
      // Sync theme select
      const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
      const themeSelect = document.getElementById('settingsThemeSelect');
      if (themeSelect) themeSelect.value = currentTheme;

      // Sync sidebar switch
      const isCollapsed = document.body.classList.contains('sidebar-collapsed');
      const collapseSwitch = document.getElementById('settingsSidebarCollapse');
      if (collapseSwitch) collapseSwitch.checked = isCollapsed;

      modal.classList.add('show');
    }
  };

  window.closeSettingsModal = function () {
    const modal = document.getElementById('settingsModal');
    if (modal) modal.classList.remove('show');
  };

  window.setThemeFromSelect = function (val) {
    if (val === 'light' || val === 'dark') {
      document.documentElement.setAttribute('data-theme', val);
      localStorage.setItem(THEME_KEY, val);
      updateThemeToggleIcons(val);
    }
  };

  window.setSidebarFromSwitch = function (collapsed) {
    if (collapsed) {
      document.body.classList.add('sidebar-collapsed');
    } else {
      document.body.classList.remove('sidebar-collapsed');
    }
    localStorage.setItem('aita_sidebar_collapsed', collapsed ? 'true' : 'false');
  };

  window.saveSettingsMock = function () {
    closeSettingsModal();
    const notification = document.createElement('div');
    notification.className = 'alert-box alert-success';
    notification.style.position = 'fixed';
    notification.style.bottom = '20px';
    notification.style.right = '20px';
    notification.style.zIndex = '9999';
    notification.style.boxShadow = '0 8px 24px rgba(0,0,0,0.3)';
    notification.innerHTML = '<i class="bi bi-check-circle-fill"></i><span>Đã lưu cài đặt hệ thống thành công!</span>';
    document.body.appendChild(notification);
    setTimeout(() => {
      notification.style.transition = 'opacity 0.5s ease';
      notification.style.opacity = '0';
      setTimeout(() => notification.remove(), 500);
    }, 3000);
  };

  // 9. CHATBOX PROTOTYPE ENGINE (FOR STUDENTS)
  window.sendSuggestedPrompt = function (text) {
    const cleanText = text.replace(/^[^\w\s\u00C0-\u1EF9]+/i, '').trim();
    const input = document.getElementById('chatInput');
    if (input) {
      input.value = cleanText;
      window.handleChatSubmit();
    }
  };

  window.handleChatSubmit = function (e) {
    if (e && e.preventDefault) e.preventDefault();
    const input = document.getElementById('chatInput');
    const container = document.getElementById('chatMessagesContainer');
    const suggestions = document.getElementById('quickSuggestions');
    if (!input || !container) return;

    const question = input.value.trim();
    if (!question) return;
    if (input.dataset.sending === 'true') return;
    input.dataset.sending = 'true';

    // Hide suggestions once chat starts
    if (suggestions) suggestions.style.display = 'none';

    // 1. Append User Message
    const userMsgHtml = `
      <div class="chat-message user-message">
        <div class="message-avatar">U</div>
        <div class="message-content">
          <div class="message-author">B&#7841;n <span class="message-time">V&#7915;a xong</span></div>
          <div class="message-bubble">${escapeHtml(question)}</div>
        </div>
      </div>
    `;
    container.insertAdjacentHTML('beforeend', userMsgHtml);
    input.value = '';
    input.style.height = 'auto';
    container.scrollTop = container.scrollHeight;

    // 2. Hiển thị Trạng thái AI Typing Indicator
    const typingId = 'typing-' + Date.now();
    const typingHtml = `
      <div class="chat-message ai-message" id="${typingId}">
        <div class="message-avatar"><i class="bi bi-robot"></i></div>
        <div class="message-content">
          <div class="message-author">AITA AI Tutor <span class="message-time">&#272;ang suy ngh&#297;...</span></div>
          <div class="message-bubble" style="display:flex; align-items:center; gap:6px; color:var(--text-subtle)">
            <span class="status-dot-pulse"></span>
            <span>&#272;ang ph&#226;n t&#237;ch ng&#7919; c&#7843;nh h&#7897;i tho&#7841;i v&#224; chu&#7849;n b&#7883; c&#226;u tr&#7843; l&#7901;i...</span>
          </div>
        </div>
      </div>
    `;
    container.insertAdjacentHTML('beforeend', typingHtml);
    container.scrollTop = container.scrollHeight;

    // 3. Gửi Request AJAX tới ChatServlet (/chat)
    const formData = new URLSearchParams();
    formData.append('message', question);
    formData.append('sessionId', container.dataset.sessionId || '');

    fetch((window.AITA_CONTEXT_PATH || '') + 'chat', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      body: formData.toString()
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Lỗi máy chủ: ' + response.status);
      }
      return response.json();
    })
    .then(data => {
      const typingEl = document.getElementById(typingId);
      if (typingEl) typingEl.remove();

      if (data.sessionId && container) {
        container.dataset.sessionId = data.sessionId;
      }

      let bannerHtml = '';
      if (data.pathCreated && data.detectedTopic) {
        bannerHtml = `
          <div style="margin-top: 10px; padding: 10px 14px; background: rgba(99, 102, 241, 0.1); border: 1px solid rgba(99, 102, 241, 0.3); border-radius: 8px; font-size: 0.85rem;">
            <i class="bi bi-signpost-split-fill" style="color: #6366f1;"></i> 
            <strong>L&#7897; tr&#236;nh h&#7885;c t&#7853;p &#273;&#227; c&#7853;p nh&#7853;t:</strong> 
            <span style="color: #818cf8;">${escapeHtml(data.detectedTopic)}</span>
            <div style="margin-top: 4px;">
              <a href="${(window.AITA_CONTEXT_PATH || '')}learning-path" style="color: #38bdf8; text-decoration: underline; font-weight: 500;">
                <i class="bi bi-arrow-right-short"></i> Xem l&#7897; tr&#236;nh c&#225; nh&#226;n h&#243;a c&#7911;a b&#7841;n
              </a>
            </div>
          </div>
        `;
      }

      const aiMsgHtml = `
        <div class="chat-message ai-message">
          <div class="message-avatar"><i class="bi bi-robot"></i></div>
          <div class="message-content">
            <div class="message-author">AITA AI Tutor <span class="message-time">V&#7915;a xong</span></div>
            <div class="message-bubble">
              ${data.answerHtml}
              ${bannerHtml}
            </div>
          </div>
        </div>
      `;
      container.insertAdjacentHTML('beforeend', aiMsgHtml);
      container.scrollTop = container.scrollHeight;
    })
    .catch(err => {
      const typingEl = document.getElementById(typingId);
      if (typingEl) typingEl.remove();

      const errMsgHtml = `
        <div class="chat-message ai-message">
          <div class="message-avatar"><i class="bi bi-exclamation-triangle-fill" style="color:#ef4444"></i></div>
          <div class="message-content">
            <div class="message-author">H&#7879; th&#7889;ng <span class="message-time">V&#7915;a xong</span></div>
            <div class="message-bubble" style="border-left: 3px solid #ef4444;">
              Kh&#244;ng th&#7875; k&#7871;t n&#7889;i v&#7899;i d&#7883;ch v&#7909; AI Tutor. Vui l&#242;ng ki&#7875;m tra m&#7841;ng ho&#7863;c th&#7917; l&#7841;i sau.
            </div>
          </div>
        </div>
      `;
      container.insertAdjacentHTML('beforeend', errMsgHtml);
      container.scrollTop = container.scrollHeight;
    })
    .finally(() => {
      input.dataset.sending = 'false';
    });
  };

  function escapeHtml(str) {
    return str.replace(/&/g, '&amp;')
              .replace(/</g, '&lt;')
              .replace(/>/g, '&gt;')
              .replace(/"/g, '&quot;')
              .replace(/'/g, '&#039;');
  }

  // DOM READY INITIALIZATION
  document.addEventListener('DOMContentLoaded', function () {
    initTheme();
    initSidebarState();
    initPasswordToggles();
    initFormLoading();
    initUserMenuPopover();

    // Attach theme toggle click handlers
    document.querySelectorAll('.btn-theme-toggle').forEach(btn => {
      btn.addEventListener('click', toggleTheme);
    });

    // Attach sidebar toggle click handlers
    document.querySelectorAll('.btn-sidebar-toggle').forEach(btn => {
      btn.addEventListener('click', toggleSidebar);
    });

    // Attach settings modal triggers (Topbar & Sidebar)
    const handleOpenSettings = function () {
      const topbarDropdown = document.getElementById('topbarUserDropdown');
      const topbarWrapper = document.getElementById('topbarUserMenuWrapper');
      const sidebarPopover = document.getElementById('sidebarUserPopover');
      const sidebarContainer = document.querySelector('.sidebar-user-container');
      if (topbarDropdown) topbarDropdown.classList.remove('show');
      if (topbarWrapper) topbarWrapper.classList.remove('open');
      if (sidebarPopover) sidebarPopover.classList.remove('show');
      if (sidebarContainer) sidebarContainer.classList.remove('open');
      openSettingsModal();
    };

    const topbarSettingsBtn = document.getElementById('btnTopbarSettings');
    if (topbarSettingsBtn) {
      topbarSettingsBtn.addEventListener('click', handleOpenSettings);
    }

    const openSettingsBtn = document.getElementById('btnOpenSettingsModal');
    if (openSettingsBtn) {
      openSettingsBtn.addEventListener('click', handleOpenSettings);
    }

    // Chat auto-resize textarea & Enter key
    const chatInput = document.getElementById('chatInput');
    if (chatInput) {
      chatInput.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' && !e.shiftKey) {
          e.preventDefault();
          window.handleChatSubmit();
        }
      });
      chatInput.addEventListener('input', function () {
        this.style.height = 'auto';
        this.style.height = Math.min(this.scrollHeight, 120) + 'px';
      });
    }

    // File attachment handler (Đính kèm file code trực tiếp)
    const attachBtn = document.getElementById('btnAttachFile');
    const fileInput = document.getElementById('chatFileInput');
    if (attachBtn && fileInput) {
      attachBtn.addEventListener('click', function () {
        fileInput.click();
      });
      fileInput.addEventListener('change', function () {
        if (!this.files || this.files.length === 0) return;
        const file = this.files[0];
        if (file.size > 2 * 1024 * 1024) {
          window.alert('File quá lớn (tối đa 2MB).');
          return;
        }
        const reader = new FileReader();
        reader.onload = function (e) {
          const content = e.target.result;
          if (chatInput) {
            const prefix = `[File: ${file.name}]\n`;
            chatInput.value = (chatInput.value ? chatInput.value + '\n\n' : '') + prefix + content;
            chatInput.style.height = 'auto';
            chatInput.style.height = Math.min(chatInput.scrollHeight, 180) + 'px';
            chatInput.focus();
          }
        };
        reader.readAsText(file, 'UTF-8');
        this.value = '';
      });
    }

  // Delete chat session
  window.deleteChatSession = function (sessionId, event) {
    if (event) {
      event.preventDefault();
      event.stopPropagation();
    }
    if (!window.confirm('Bạn có chắc chắn muốn xóa cuộc trò chuyện này khỏi lịch sử?')) return;

    fetch((window.AITA_CONTEXT_PATH || '') + 'chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
      body: new URLSearchParams({ action: 'deleteSession', sessionId: sessionId }).toString()
    })
    .then(response => response.ok ? response.json() : Promise.reject(new Error('delete failed')))
    .then(data => {
      if (data.status === 'success') {
        const container = document.getElementById('chatMessagesContainer');
        if (container && container.dataset.sessionId == sessionId) {
          window.location.href = (window.AITA_CONTEXT_PATH || '') + 'chat';
        } else {
          window.location.reload();
        }
      } else {
        window.alert(data.message || 'Không thể xóa cuộc trò chuyện.');
      }
    })
    .catch(() => {
      window.alert('Không thể kết nối máy chủ để xóa cuộc trò chuyện.');
    });
  };

  // Clear chat / New chat buttons
  function initNewChatButtons() {
    const triggerNewChat = function () {
      const btn = this;
      if (btn.dataset.creating === 'true') return;
      btn.dataset.creating = 'true';
      fetch((window.AITA_CONTEXT_PATH || '') + 'chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: new URLSearchParams({ action: 'newSession' }).toString()
      })
      .then(response => response.ok ? response.json() : Promise.reject(new Error('new session failed')))
      .then(data => {
        if (!data.sessionId) throw new Error('missing session id');
        window.location.href = (window.AITA_CONTEXT_PATH || '') + 'chat?sessionId=' + encodeURIComponent(data.sessionId);
      })
      .catch(() => {
        btn.dataset.creating = 'false';
        window.alert('Không thể tạo cuộc trò chuyện mới. Vui lòng thử lại.');
      });
    };

    const clearChatBtn = document.getElementById('btnClearChat');
    if (clearChatBtn) clearChatBtn.addEventListener('click', triggerNewChat);

    const newChatBtn = document.getElementById('btnNewChat');
    if (newChatBtn) newChatBtn.addEventListener('click', triggerNewChat);
  }
  initNewChatButtons();

    // Close mobile sidebar on backdrop click
    document.addEventListener('click', function (e) {
      if (document.body.classList.contains('sidebar-mobile-open')) {
        const sidebar = document.querySelector('.app-sidebar');
        const toggleBtn = e.target.closest('.btn-sidebar-toggle');
        if (sidebar && !sidebar.contains(e.target) && !toggleBtn) {
          document.body.classList.remove('sidebar-mobile-open');
        }
      }
    });
  });

  // Run init immediately to prevent theme flash
  initTheme();
})();

