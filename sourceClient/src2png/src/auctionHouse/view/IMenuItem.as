// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.IMenuItem

package auctionHouse.view
{
    import flash.events.IEventDispatcher;

    public interface IMenuItem extends IEventDispatcher 
    {

        function get info():Object;
        function get x():Number;
        function get y():Number;
        function set x(_arg_1:Number):void;
        function set y(_arg_1:Number):void;
        function get isOpen():Boolean;
        function set isOpen(_arg_1:Boolean):void;
        function set enable(_arg_1:Boolean):void;

    }
}//package auctionHouse.view

