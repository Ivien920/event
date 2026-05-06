<?php // UMU Events — Footer ?>
</main>

<footer class="site-footer">
    <div class="footer-inner">
        <div class="footer-brand">
            <div class="footer-logo-circle">UMU</div>
            <div>
                <p class="footer-name">Uganda Martyrs University</p>
                <p class="footer-sub">Nkozi, Uganda &bull; Est. 1993</p>
            </div>
        </div>
        <p class="footer-copy">&copy; <?= date('Y') ?> UMU Events Management System &mdash; All rights reserved.</p>
    </div>
</footer>

<script>
// User dropdown toggle
document.querySelector('.user-menu')?.addEventListener('click', function(e) {
    e.stopPropagation();
    this.classList.toggle('open');
});
document.addEventListener('click', () => {
    document.querySelector('.user-menu')?.classList.remove('open');
});
</script>
</body>
</html>
