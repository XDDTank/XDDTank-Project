// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.IAnimate

package game.animations
{
    import game.view.map.MapView;

    public interface IAnimate 
    {

        function get level():int;
        function prepare(_arg_1:AnimationSet):void;
        function canAct():Boolean;
        function update(_arg_1:MapView):Boolean;
        function canReplace(_arg_1:IAnimate):Boolean;
        function cancel():void;
        function get ownerID():int;
        function get finish():Boolean;

    }
}//package game.animations

