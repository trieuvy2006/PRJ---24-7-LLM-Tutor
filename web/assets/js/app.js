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

  // DOM READY INITIALIZATION
  document.addEventListener('DOMContentLoaded', function () {
    initTheme();
    initSidebarState();
    initPasswordToggles();
    initFormLoading();

    // Attach theme toggle click handlers
    document.querySelectorAll('.btn-theme-toggle').forEach(btn => {
      btn.addEventListener('click', toggleTheme);
    });

    // Attach sidebar toggle click handlers
    document.querySelectorAll('.btn-sidebar-toggle').forEach(btn => {
      btn.addEventListener('click', toggleSidebar);
    });

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
