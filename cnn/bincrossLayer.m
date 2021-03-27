classdef bincrossLayer < nnet.layer.ClassificationLayer
        
    properties
        % (Optional) Layer properties.

        % Layer properties go here.
    end
 
    methods
        function layer = bincrossLayer(name)           
            % (Optional) Create a myClassificationLayer.
            % Set layer name.
            layer.Name = name;

            % Set layer description.
            layer.Description = 'Bin Cross-Entropy and DSC';    
        end

        function loss = forwardLoss(layer, Y, T)
            % Return the loss between the predictions Y and the training 
            % targets T.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         loss  - Loss between Y and T


            % Calculate sum of squares.
            crossEntropy = crossentropy(Y,T,'DataFormat','SSCB');
           % crossEntropy = sum(sum((1/2)*T.*log(Y),1),2);
            dice = sum(sum(sum(sum((Y.*T)./(Y + T),1),2),3));
            % Take mean over mini-batch.
            N = size(Y,4);
            loss = (crossEntropy + dice)/N;
        end
    end
end