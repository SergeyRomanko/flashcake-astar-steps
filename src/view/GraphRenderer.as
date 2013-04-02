package view{
	import astar.Graph;
	import astar.GraphNode;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class GraphRenderer extends Sprite{
		
		public function draw(graph:Graph):void{
			removeChildren()
			for (var x:int = 0; x < graph.width; x++) {
				for (var y:int = 0; y < graph.height; y++) {
					addChild(new GraphNodeVisual(graph.getNodeAt(x,y)))
				}
			}
			
			var l:int = 'A'.charCodeAt(0);
			for (x = 0; x < graph.width; x++) {
				var m:TextField = getMarker(String.fromCharCode(l++));
				addChild(m);
				m.x += x*72+35;
				m.y = -2;
			}
			for (y = 0; y < graph.height; y++) {
				m = getMarker(String(y));
				addChild(m);
				m.y += y*72+40;
				m.x = -1;
			}
			
		}
		
		private function getMarker(label:String):TextField{
			var textField:TextField = new TextField();
			textField.selectable = false;
			textField.mouseEnabled = false;
			//textField.border = true;
			textField.defaultTextFormat = new TextFormat('_typewriter',10,0xCECECE,true);
			textField.width = 20;
			textField.height = 15;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.text = label;
			return textField;
		}
		
		public function update(graph:Graph,path:Vector.<GraphNode>,openList:Vector.<GraphNode>,closedList:Vector.<GraphNode>):void{
			for (var x:int = 0; x < graph.width; x++) {
				for (var y:int = 0; y < graph.height; y++) {
					var node:GraphNode = graph.getNodeAt(x,y);
					var visualNode:GraphNodeVisual = getVisualNode(node);

					if(openList.indexOf(node)!=-1 || closedList.indexOf(node)!=-1){
						if(path && path.indexOf(node)!=-1){
							visualNode.showPathPoint();
						}else{
							visualNode.showDirection(getDitection(node));
						}
						visualNode.showDetails();
						visualNode.showType(openList.indexOf(node)!=-1);
					}else{
						visualNode.hideDetails();
					}
				}
			}
		}
		
		private function getDitection(node:GraphNode):Number{
			if(node.parent){
				var x:int = node.x - node.parent.x;
				var y:int = node.y - node.parent.y;
				
				if(x==1 && y==1){
					return GraphNodeVisual.TOP_LEFT;
				}else if(x==1 && y==0){
					return GraphNodeVisual.LEFT;
				}else if(x==1 && y==-1){
					return GraphNodeVisual.BOTTOM_LEFT;
				}else if(x==0 && y==-1){
					return GraphNodeVisual.BOTTOM;
				}else if(x==-1 && y==-1){
					return GraphNodeVisual.BOTTOM_RIGHT;
				}else if(x==-1 && y==0){
					return GraphNodeVisual.RIGHT;
				}else if(x==-1 && y==1){
					return GraphNodeVisual.TOP_RIGHT;
				}else if(x==0 && y==1){
					return GraphNodeVisual.TOP;
				}
			}
			return Number.NaN;
		}
		

		
		private function getVisualNode(node:GraphNode):GraphNodeVisual{
			for (var i:int = 0; i < numChildren; i++) {
				var curVisualNode:GraphNodeVisual = getChildAt(i) as GraphNodeVisual;
				if(curVisualNode.graphNode.x == node.x && curVisualNode.graphNode.y == node.y){
					return curVisualNode
				}
			}
			return null;
		}
		
		public function showStartAndEndNodes(start:GraphNode, end:GraphNode):void{
			
			var startVisualNode:GraphNodeVisual = getVisualNode(start);
			var endVisualNode:GraphNodeVisual = getVisualNode(end);
			
			startVisualNode.showCrossMarker(false);
			endVisualNode.showCrossMarker(true);
			
		}
	}
}


