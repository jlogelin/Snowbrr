
<div class="row">
    <div class="col-sm-3"></div>
    <div class="col-sm-3">
        <div class="rating-block">
            <h4>Average user rating</h4>
            <h2 class="bold padding-bottom-7"><stats:averageRating target="${target}"/> <small>/ 5</small></h2>

            <stats:renderStars target="${target}"/>

        </div>
    </div>

    <div class="col-sm-3">
        <h4>Rating breakdown</h4>
        <div class="pull-left">
            <div class="pull-left" style="width:35px; line-height:1;">
                <div style="height:9px; margin:5px 0;">5 <span class="glyphicon glyphicon-star"></span></div>
            </div>
            <div class="pull-left" style="width:180px;">
                <div class="progress" style="height:20px; margin:2px 0;">
                    <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="5" aria-valuemin="0" aria-valuemax="5" style="width: <stats:fiveStarPct target="${target}"/>%">
                        <span class="sr-only">80% Complete (danger)</span>
                    </div>
                </div>
            </div>
            <div class="pull-right" style="margin-left:10px;"><stats:fiveStarCount target="${target}"/></div>
        </div>
        <div class="pull-left">
            <div class="pull-left" style="width:35px; line-height:1;">
                <div style="height:9px; margin:5px 0;">4 <span class="glyphicon glyphicon-star"></span></div>
            </div>
            <div class="pull-left" style="width:180px;">
                <div class="progress" style="height:20px; margin:2px 0;">
                    <div class="progress-bar progress-bar-primary" role="progressbar" aria-valuenow="4" aria-valuemin="0" aria-valuemax="5" style="width: <stats:fourStarPct target="${target}"/>%">
                        <span class="sr-only">80% Complete (danger)</span>
                    </div>
                </div>
            </div>
            <div class="pull-right" style="margin-left:10px;"><stats:fourStarCount target="${target}"/></div>
        </div>
        <div class="pull-left">
            <div class="pull-left" style="width:35px; line-height:1;">
                <div style="height:9px; margin:5px 0;">3 <span class="glyphicon glyphicon-star"></span></div>
            </div>
            <div class="pull-left" style="width:180px;">
                <div class="progress" style="height:20px; margin:2px 0;">
                    <div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="3" aria-valuemin="0" aria-valuemax="5" style="width: <stats:threeStarPct target="${target}"/>%">
                        <span class="sr-only">80% Complete (danger)</span>
                    </div>
                </div>
            </div>
            <div class="pull-right" style="margin-left:10px;"><stats:threeStarCount target="${target}"/></div>
        </div>
        <div class="pull-left">
            <div class="pull-left" style="width:35px; line-height:1;">
                <div style="height:9px; margin:5px 0;">2 <span class="glyphicon glyphicon-star"></span></div>
            </div>
            <div class="pull-left" style="width:180px;">
                <div class="progress" style="height:20px; margin:2px 0;">
                    <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="2" aria-valuemin="0" aria-valuemax="5" style="width: <stats:twoStarPct target="${target}"/>%">
                        <span class="sr-only">80% Complete (danger)</span>
                    </div>
                </div>
            </div>
            <div class="pull-right" style="margin-left:10px;"><stats:twoStarCount target="${target}"/></div>
        </div>
        <div class="pull-left">
            <div class="pull-left" style="width:35px; line-height:1;">
                <div style="height:9px; margin:5px 0;">1 <span class="glyphicon glyphicon-star"></span></div>
            </div>
            <div class="pull-left" style="width:180px;">
                <div class="progress" style="height:20px; margin:2px 0;">
                    <div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="1" aria-valuemin="0" aria-valuemax="5" style="width: <stats:oneStarPct target="${target}"/>%">
                        <span class="sr-only">80% Complete (danger)</span>
                    </div>
                </div>
            </div>
            <div class="pull-right" style="margin-left:10px;"><stats:oneStarCount target="${target}"/></div>
        </div>
    </div>
</div>