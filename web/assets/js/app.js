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

    // Hide suggestions once chat starts
    if (suggestions) suggestions.style.display = 'none';

    // 1. Append User Message
    const userMsgHtml = `
      <div class="chat-message user-message">
        <div class="message-avatar">U</div>
        <div class="message-content">
          <div class="message-author">Bạn <span class="message-time">Vừa xong</span></div>
          <div class="message-bubble">${escapeHtml(question)}</div>
        </div>
      </div>
    `;
    container.insertAdjacentHTML('beforeend', userMsgHtml);
    input.value = '';
    input.style.height = 'auto';
    container.scrollTop = container.scrollHeight;

    // 2. Simulate AI Typing Indicator
    const typingId = 'typing-' + Date.now();
    const typingHtml = `
      <div class="chat-message ai-message" id="${typingId}">
        <div class="message-avatar"><i class="bi bi-robot"></i></div>
        <div class="message-content">
          <div class="message-author">AITA AI Tutor <span class="message-time">Đang suy nghĩ...</span></div>
          <div class="message-bubble" style="display:flex; align-items:center; gap:6px; color:var(--text-subtle)">
            <span class="status-dot-pulse"></span>
            <span>Đang tra cứu cơ sở tri thức và soạn câu trả lời sư phạm...</span>
          </div>
        </div>
      </div>
    `;
    container.insertAdjacentHTML('beforeend', typingHtml);
    container.scrollTop = container.scrollHeight;

    // 3. Simulated AI Pedagogical Response
    setTimeout(function () {
      const typingEl = document.getElementById(typingId);
      if (typingEl) typingEl.remove();

      let answerHtml = '';
      const qLower = question.toLowerCase();

      if (qLower.includes('vòng đời') || qLower.includes('lifecycle') || qLower.includes('httpservlet')) {
        answerHtml = `
          <p>Tuyệt vời! Vòng đời của một <strong>HttpServlet</strong> trong Java Web gồm 3 giai đoạn then chốt:</p>
          <ol>
            <li><strong>Khởi tạo (<code>init()</code>):</strong> Chỉ được gọi duy nhất một lần khi Servlet được nạp vào bộ nhớ bởi Web Container (Tomcat). Dùng để kết nối tài nguyên hoặc cấu hình ban đầu.</li>
            <li><strong>Phục vụ yêu cầu (<code>service()</code>):</strong> Được gọi mỗi khi có client gửi request. Phương thức này sẽ phân tích HTTP Method để gọi tiếp <code>doGet()</code> hoặc <code>doPost()</code>.</li>
            <li><strong>Hủy giải phóng (<code>destroy()</code>):</strong> Được gọi một lần trước khi Servlet bị dỡ bỏ hoặc server dừng, dùng để đóng kết nối CSDL và giải phóng bộ nhớ.</li>
          </ol>
          <p>💡 <em>Gợi ý thực hành:</em> Bạn có thể đặt <code>System.out.println("init called")</code> vào Servlet trong dự án AITA để quan sát console khi ứng dụng khởi chạy!</p>
        `;
      } else if (qLower.includes('lỗi') || qLower.includes('nullpointer') || qLower.includes('500')) {
        answerHtml = `
          <p>Đối với lỗi <code>NullPointerException</code> hoặc HTTP Status 500 trong ứng dụng Servlet/JSP, nguyên nhân phổ biến nhất là:</p>
          <ul>
            <li><strong>Đọc tham số chưa tồn tại:</strong> <code>request.getParameter("key")</code> trả về <code>null</code> do tên ô <code>name="..."</code> trong form HTML không khớp với code Java.</li>
            <li><strong>Kết nối Database chưa mở:</strong> Biến <code>connection</code> trong <code>DBContext</code> chưa kết nối thành công tới SQL Server (hãy kiểm tra user/pass SQL và cổng 1433).</li>
            <li><strong>Đối tượng Session chưa có:</strong> Gọi <code>session.getAttribute("currentUser")</code> khi người dùng chưa đăng nhập.</li>
          </ul>
          <p>🔍 Bạn có thể dán đoạn stack trace lỗi hoặc đoạn code Servlet nghi vấn vào đây để tôi soi chi tiết từng dòng nhé!</p>
        `;
      } else {
        answerHtml = `
          <p>Tôi đã tiếp nhận câu hỏi của bạn về: <em>"${escapeHtml(question)}"</em>.</p>
          <p>✨ <strong>Hướng tiếp cận giải quyết:</strong></p>
          <ul>
            <li>Xác định vai trò của thành phần theo mô hình <strong>MVC2</strong>: Dữ liệu (Model), Giao diện hiển thị (JSP/JSTL), hay Luồng điều hướng (Servlet Controller).</li>
            <li>Đảm bảo mã nguồn tuân thủ nguyên tắc đóng gói (Encapsulation) và kiểm tra kỹ các ràng buộc khóa ngoại trong CSDL <code>AITA_DB</code>.</li>
          </ul>
          <p>🚀 <em>Lưu ý:</em> Mô hình AI LLM Engine trực tiếp đang được kết nối với Gemini/GPT-4o. Hiện tại hệ thống đang chạy chế độ mô phỏng phản hồi gia sư.</p>
        `;
      }

      const aiMsgHtml = `
        <div class="chat-message ai-message">
          <div class="message-avatar"><i class="bi bi-robot"></i></div>
          <div class="message-content">
            <div class="message-author">AITA AI Tutor <span class="message-time">Vừa xong</span></div>
            <div class="message-bubble">${answerHtml}</div>
          </div>
        </div>
      `;
      container.insertAdjacentHTML('beforeend', aiMsgHtml);
      container.scrollTop = container.scrollHeight;
    }, 1200);
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

    // Clear chat button
    const clearChatBtn = document.getElementById('btnClearChat');
    if (clearChatBtn) {
      clearChatBtn.addEventListener('click', function () {
        const container = document.getElementById('chatMessagesContainer');
        const suggestions = document.getElementById('quickSuggestions');
        if (container) {
          const messages = container.querySelectorAll('.chat-message:not(:first-child)');
          messages.forEach(m => m.remove());
        }
        if (suggestions) suggestions.style.display = 'flex';
      });
    }

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

