@foreach($items as $item)
    <?php
    if ($item->hasChildren()){
        if ($item->children()->where('isActive',true)->first() !== null){
            $active = 'active';
        }else{
            $active = '';
        }
        $rawUrl = $item->url();
        $hashPos = strpos($rawUrl, '#');
        $targetId = ($hashPos !== false) ? substr($rawUrl, $hashPos + 1) : ($item->nickname() ?: 'menu-' . $item->id);
    }else{
        $active = '';
        $targetId = '';
    }
    ?>
    <li @lm_attrs($item) @lm_endattrs>
        @if($item->link) <a @lm_attrs($item->link)
            @if($item->hasChildren()) data-bs-toggle="collapse" data-toggle="collapse" data-bs-target="#{{ $targetId }}" data-target="#{{ $targetId }}" role="button" aria-expanded="{{ $active != '' ? 'true' : 'false' }}" aria-controls="{{ $targetId }}" href="#{{ $targetId }}" @else class="nav-link" href="{!! $item->url() !!}" @endif @lm_endattrs>
            {!! $item->title !!}
            @if($item->hasChildren())
                <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
            @endif
        </a>
        @else
            <span class="navbar-text">{!! $item->title !!}</span>
        @endif
        @if($item->hasChildren())
            <ul class="submenu collapse {{ $active != '' ? 'show' : '' }}" id="{{ $targetId }}">
                @include(config('laravel-menu.views.bootstrap-items'),array('items' => $item->children()))
            </ul>
        @endif
    </li>
    @if($item->divider)
        <li{!! Lavary\Menu\Builder::attributes($item->divider) !!}></li>
    @endif
@endforeach
