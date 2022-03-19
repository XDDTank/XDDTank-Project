// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.experience.ExpTypeTxt

package game.view.experience
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import com.greensock.TweenLite;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class ExpTypeTxt extends Sprite implements Disposeable 
    {

        public static const FIGHTING_EXP:String = "fightingExp";
        public static const ATTATCH_EXP:String = "attatchExp";
        public static const EXPLOIT_EXP:String = "exploitExp";

        private var _grayTxt:Bitmap;
        private var _lightTxt:Bitmap;
        private var _valueTxt:FilterFrameText;
        private var _value:Number;
        private var _idx:int;
        private var _type:String;
        private var _movie:MovieClip;

        public function ExpTypeTxt(_arg_1:String, _arg_2:int, _arg_3:Number=0)
        {
            this._idx = _arg_2;
            this._type = _arg_1;
            this._value = _arg_3;
            this.init();
        }

        protected function init():void
        {
            var _local_1:Point;
            switch (this._type)
            {
                case FIGHTING_EXP:
                    this._grayTxt = ComponentFactory.Instance.creatBitmap(("asset.experience.fightExpItemTxt_a" + String(this._idx)));
                    this._lightTxt = ComponentFactory.Instance.creatBitmap(("asset.experience.fightExpItemTxt_b" + String(this._idx)));
                    this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("experience.expTypeTxt");
                    break;
                case ATTATCH_EXP:
                    if (this._idx == 7)
                    {
                        this._movie = ComponentFactory.Instance.creat("asset.expView.goForPowerMovieAsset");
                        _local_1 = ComponentFactory.Instance.creatCustomObject("gameOver.goForPowerPosition");
                        this._movie.x = _local_1.x;
                        this._movie.y = _local_1.y;
                    }
                    else
                    {
                        if (this._idx == 8)
                        {
                            this._grayTxt = ComponentFactory.Instance.creatBitmap("asset.experience.exploitExpItemTxt_a4");
                            this._lightTxt = ComponentFactory.Instance.creatBitmap(("asset.experience.attachExpItemTxt_b" + String(this._idx)));
                        }
                        else
                        {
                            this._grayTxt = ComponentFactory.Instance.creatBitmap(("asset.experience.attachExpItemTxt_a" + String(this._idx)));
                            this._lightTxt = ComponentFactory.Instance.creatBitmap(("asset.experience.attachExpItemTxt_b" + String(this._idx)));
                        };
                    };
                    this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("experience.expTypeTxt");
                    break;
                case EXPLOIT_EXP:
                    this._grayTxt = ComponentFactory.Instance.creatBitmap(("asset.experience.exploitExpItemTxt_a" + String(this._idx)));
                    this._lightTxt = ComponentFactory.Instance.creatBitmap(("asset.experience.exploitExpItemTxt_b" + String(this._idx)));
                    this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("experience.exploitTypeTxt");
            };
            if (this._valueTxt)
            {
                this._valueTxt.alpha = 0;
            };
            if (this._grayTxt)
            {
                addChild(this._grayTxt);
            };
            if (Boolean(this.value))
            {
                ExpTweenManager.Instance.appendTween(TweenLite.to(this._valueTxt, 0.15, {
                    "y":"-30",
                    "alpha":1,
                    "onStart":this.play
                }));
                ExpTweenManager.Instance.appendTween(TweenLite.to(this._valueTxt, 0.3, {
                    "y":"-20",
                    "alpha":0,
                    "delay":0.1
                }));
            };
        }

        public function play():void
        {
            SoundManager.instance.play("142");
            if (((this._type == ATTATCH_EXP) && (this._idx == 7)))
            {
                this._valueTxt.visible = false;
                if (this._movie)
                {
                    addChild(this._movie);
                    this._movie.play();
                };
            }
            else
            {
                addChild(this._lightTxt);
                addChild(this._valueTxt);
                this._grayTxt.parent.removeChild(this._grayTxt);
                if (this.value < 0)
                {
                    this._valueTxt.text = (String(this.value) + "  ");
                }
                else
                {
                    this._valueTxt.text = (("+" + String(this.value)) + "  ");
                };
            };
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get value():Number
        {
            return (this._value);
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._lightTxt);
            ObjectUtils.disposeObject(this._valueTxt);
            this._lightTxt = null;
            this._valueTxt = null;
            if (this._grayTxt)
            {
                ObjectUtils.disposeObject(this._grayTxt);
                this._grayTxt = null;
            };
            ObjectUtils.disposeObject(this._movie);
            this._movie = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.experience

